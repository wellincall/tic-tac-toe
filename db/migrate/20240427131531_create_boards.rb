class CreateBoards < ActiveRecord::Migration[7.1]
  def change
    create_table :boards do |t|
      t.string :current_player, limit: 1
      t.string :winner, limit: 1
      t.string :cells, limit: 9, default: " " * 9

      t.timestamps
    end
  end
end
