# frozen_string_literal: true

class Board < ApplicationRecord
  def fill(position)
    return :invalid if position < 1 || position > 9
    return :invalid if cells[position - 1] != " "

    cells[position - 1] = current_player
    :ok
  end

  def has_winner?
    return true if won_in_row?
    return true if won_in_column?
    return true if won_in_diagonal?

    false
  end

  def next_player 
    current_player == "X" ? "O" : "X"
  end

  def tied?
    cells.count(" ") == 0 && !has_winner?
  end

  private

  def won_in_row?
    (same_player_in_positions?(0,1,2)) ||
      (same_player_in_positions?(3,4,5)) ||
      (same_player_in_positions?(6,7,8))
  end

  def won_in_column?
    (same_player_in_positions?(0,3,6)) ||
      (same_player_in_positions?(1,4,7)) ||
      (same_player_in_positions?(2,5,8))
  end

  def won_in_diagonal?
    (same_player_in_positions?(0,4,8)) ||
      (same_player_in_positions?(2,4,6))
  end

  def same_player_in_positions?(p1, p2, p3)
    return false if cells[p1] == " " || cells[p2] == " " || cells[p3] == " "

    cells[p1] == cells[p2] && cells[p1] == cells[p3]
  end
end
