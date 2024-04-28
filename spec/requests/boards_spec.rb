# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Board endpoints" do
  describe "GET /boards" do
    let(:url) { "/boards" }
    it "returns an :ok status code" do
      get url

      expect(response).to have_http_status(:ok)
    end

    it "renders a page to start game" do
      get url
      
      html_response = Nokogiri::HTML(response.body)
      expect(html_response.css("[data-test='start-game']")).not_to be_empty
    end
  end

  describe "POST /boards" do
    let(:url) { "/boards" }

    it "creates a board record" do
      expect{ post url }.to change{ Board.count }.by(1)
    end
    
    it "redirects to edit board page" do
      post url
      board = Board.last

      expect(response).to redirect_to(edit_board_path(board.id))
    end
  end

  describe "PUT /boards/:id" do
    let(:board) { Board.create(current_player: "X") }
    let(:params) { { board: { position: 1 } } }

    it "redirects to edit board page" do
      put board_path(board), params: params

      expect(response).to redirect_to(edit_board_path(board.id))
    end

    it "changes the current player" do
      expect { put board_path(board), params: params }.to change {board.reload.current_player }
    end

    it "stores current player in given position" do
      put board_path(board), params: params

      expect(board.reload.cells).to eq(" X" + " " * 7)
    end

    context "when current move ends the game" do
      let(:board) { Board.create(current_player: "X", cells: "XO XO    ") }
      let(:params) { { board: { position: 6 } } }

      it "sets current player as winner" do
        put board_path(board), params: params

        expect(board.reload.winner).to eq("X")
      end

      it "sets current user as blank" do
        put board_path(board), params: params

        expect(board.reload.current_player).to eq("")
      end
    end
  end

  describe "GET /boards/:id/edit" do
    let(:board) { Board.create(current_player: "X") }

    it "returns an :ok status" do
      get edit_board_path(board)

      expect(response).to have_http_status(:ok)
    end

    it "adds fields to register movement for current player" do
      get edit_board_path(board)

      html_response = Nokogiri::HTML(response.body)
      expect(html_response.css("[data-test='filler-input']")).not_to be_empty
    end

    it "displays current player message" do
      get edit_board_path(board)

      html_response = Nokogiri::HTML(response.body)
      expect(html_response.css("[data-test='current-player-message']")).not_to be_empty
    end

    context "when it is a tie" do
      let(:board) { Board.create(cells: "XOXOXOOXO") }

      it "does not add fields to register movement for current player" do
        get edit_board_path(board)

        html_response = Nokogiri::HTML(response.body)
        expect(html_response.css("[data-test='filler-input']")).to be_empty
      end

      it "displays tie message" do
        get edit_board_path(board)

        html_response = Nokogiri::HTML(response.body)
        expect(html_response.css("[data-test='tie-message']")).not_to be_empty
      end
    end

    context "when there is a winner" do
      let(:board) { Board.create(cells: "XO XO X  ") }
      it "does not add fields to register movement for current player" do
        get edit_board_path(board)

        html_response = Nokogiri::HTML(response.body)
        expect(html_response.css("[data-test='filler-input']")).to be_empty
      end

      it "displays tie message" do
        get edit_board_path(board)

        html_response = Nokogiri::HTML(response.body)
        expect(html_response.css("[data-test='winner-message']")).not_to be_empty
      end
    end
  end
end
