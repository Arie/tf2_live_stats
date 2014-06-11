class AddMatchIdIndexToLogLlines < ActiveRecord::Migration
  def change
    add_index :log_lines, :match_id
  end
end
