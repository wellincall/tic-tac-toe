# frozen_string_literal: true

require "rails_helper"

RSpec.describe Filler do
  describe "#perform(position)" do
    context "when position is allowed" do
      let(:mocked_board) do 
        instance_double(Board, fill: :ok, has_winner?: false, tied?: false, next_player: "X") 
      end

      it "returns success flag as true" do
        filler = Filler.new(mocked_board)
        response = filler.perform(3)

        expect(response[:success]).to eq(true)
      end

      it "returns who is the next player" do
        filler = Filler.new(mocked_board)
        response = filler.perform(3)

        expect(response[:next_player]).to eq("X")
      end

      it "returns flag confirming game is not ended" do
        filler = Filler.new(mocked_board)
        response = filler.perform(3)

        expect(response[:ended]).to eq(false)
      end

      context "when it ends game" do
        let(:mocked_board) do 
          instance_double(Board, fill: :ok, has_winner?: true, next_player: "X") 
        end

        it "returns next player as empty" do
          filler = Filler.new(mocked_board)
          response = filler.perform(3)

          expect(response[:next_player]).to eq("")
        end

        it "returns flag confirming game is ended" do
          filler = Filler.new(mocked_board)
          response = filler.perform(3)

          expect(response[:ended]).to eq(true)
        end

        context "due to a tie" do
          let(:mocked_board) do
            instance_double(Board, fill: :ok, has_winner?: false, next_player: "X", tied?: true) 
          end

          it "returns flag confirming game is ended" do
            filler = Filler.new(mocked_board)
            response = filler.perform(3)

            expect(response[:ended]).to eq(true)
          end

          it "returns next player as empty" do
            filler = Filler.new(mocked_board)
            response = filler.perform(3)

            expect(response[:next_player]).to eq("")
          end
        end
      end
    end

    context "when position is invalid" do
      let(:mocked_board) do 
        instance_double(
          Board,
          fill: :invalid,
          has_winner?: false,
          next_player: "X",
          current_player: "O"
        ) 
      end

      it "returns success flag false" do
        filler = Filler.new(mocked_board)
        response = filler.perform(3)

        expect(response[:success]).to eq(false)
      end

      it "returns next player as current_player" do
        filler = Filler.new(mocked_board)
        response = filler.perform(3)

        expect(response[:next_player]).to eq("O")
      end

      it "returns flag confirming game is not ended" do
        filler = Filler.new(mocked_board)
        response = filler.perform(3)

        expect(response[:ended]).to eq(false)
      end
    end
  end
end
