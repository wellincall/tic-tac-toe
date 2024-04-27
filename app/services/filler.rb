# frozen_string_literal: true

class Filler
  def initialize(board)
    @board = board
  end

  def perform(position)
    play_response = board.fill(position)
    return invalid_action_response if play_response == :invalid

    game_ended = board.has_winner?
    {
      success: true,
      next_player: game_ended ? "" : board.next_player,
      ended: game_ended
    }
  end

  private

  attr_reader :board

  def invalid_action_response
    {
      success: false,
      next_player: board.current_player,
      ended: false 
    }
  end
end
