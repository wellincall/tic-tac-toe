# frozen_string_literal: true

class BoardsController < ApplicationController
  before_action :set_board, only: [:edit, :update]

  def index
    @boards = Board.all.order(id: :desc)
  end

  def create
    board = Board.create(current_player: initial_player)
    redirect_to edit_board_path(board)
  end

  def edit
    @board = Board.find_by(id: params[:id])
  end

  def update
    filler = Filler.new(@board)
    response = filler.perform(params[:board][:position].to_i)
    if response[:success]
      @board.update(
        cells: @board.cells,
        current_player: response[:next_player],
        winner: response[:ended] ? @board.current_player : nil
      )
    end
    redirect_to edit_board_path(@board)
  end

  private

  def initial_player
    ["X", "O"].sample
  end

  def set_board
    @board = Board.find_by(id: params[:id])
  end
end
