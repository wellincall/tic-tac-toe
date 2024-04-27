# frozen_string_literal: true

require "rails_helper"

RSpec.describe Board do
  describe "#fill(position)" do
    it "adds current player to position" do
      board = Board.new(current_player: "X")
      board.fill(3)

      expect(board.cells[2]).to eq("X")
    end

    it "returns :ok symbol" do
      board = Board.new(current_player: "X")

      expect(board.fill(2)).to eq(:ok)
    end

    context "when position is already filled in" do
      it "does not change board" do
        board = Board.new(current_player: "X", cells: "X" + " " * 8)

        expect { board.fill(1) }.not_to change { board.cells }
      end

      it "returns :invalid symbol" do
        board = Board.new(current_player: "X", cells: "X" + " " * 8)

        expect(board.fill(1)).to eq(:invalid)
      end
    end

    context "when position is outside range 1-9" do
      it "does not change board" do
        board = Board.new(current_player: "X")

        expect { board.fill(10) }.not_to change { board.cells }
      end

      it "returns :invalid symbol" do
        board = Board.new(current_player: "X")

        expect(board.fill(10)).to eq(:invalid)
      end
    end
  end

  describe "#next_player" do
    context "when current_player is X" do
      it "returns O" do
        board = Board.new(current_player: "X")

        expect(board.next_player).to eq("O")
      end
    end

    context "when current_player is O" do
      it "sets current_player to X" do
        board = Board.new(current_player: "O")

        expect(board.next_player).to eq("X")
      end
    end
  end

  describe "#has_winner?" do
    context "when won in row" do
      it "returns true" do
        win_conditions = [
          "XXX"+ "   " + "   ",
          "   " + "OOO" + "   ",
          "   " + "   " + "XXX"
        ]
        win_conditions.each do |win_condition|
          board = Board.new(cells: win_condition)
          
          expect(board.has_winner?).to eq(true)
        end
      end
    end

    context "when won in column" do
      it "returns true" do
        win_conditions = [
          "X  "+ "X  " + "X  ",
          " X " + " X " + " X ",
          "  O" + "  O" + "  O"
        ]
        win_conditions.each do |win_condition|
          board = Board.new(cells: win_condition)
          
          expect(board.has_winner?).to eq(true)
        end
      end
    end

    context "when won in diagonal" do
      it "returns true" do
        win_conditions = [
          "X  "+ " X " + "  X",
          "O  " + " O " + "  O"
        ]
        win_conditions.each do |win_condition|
          board = Board.new(cells: win_condition)
          
          expect(board.has_winner?).to eq(true)
        end
      end
    end

    it "returns false" do
      board = Board.new(cells: "XOOOOX   ")

      expect(board.has_winner?).to eq(false)
    end
  end

  describe "#tied?" do
    context "when there is blank cells and no winner" do
      it "returns false" do
        board = Board.new(cells: "XOOOOX   ")

        expect(board.tied?).to eq(false)
      end
    end

    context "when there is a winner" do
      it "returns false" do
        board = Board.new(cells: "XOXXOX O ")

        expect(board.tied?).to eq(false)
      end
    end
  
    it "returns true" do
      board = Board.new(cells: "XOXXOXOXO")

      expect(board.tied?).to eq(true)
    end
  end
end
