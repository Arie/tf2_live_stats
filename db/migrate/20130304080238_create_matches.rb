class CreateMatches < ActiveRecord::Migration
  def up
    create_table :matches do |t|
      t.string :host
      t.string :rcon
      t.string :secret
      t.timestamps
    end
  end

  def down
    drop_table :matches
  end
end
