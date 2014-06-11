class CreateTableLogLines < ActiveRecord::Migration

  def up
    create_table :log_lines do |t|
      t.integer :match_id
      t.text :line
      t.timestamps
    end
    add_index :log_lines, :created_at
  end

  def down
    drop_table :log_lines
  end

end
