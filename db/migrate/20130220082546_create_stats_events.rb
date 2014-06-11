class CreateStatsEvents < ActiveRecord::Migration
  def up
    create_table :stats_events do |t|
      t.integer :log_line_id
      t.integer :match_id
      t.datetime :time

      t.string   :event_type

      t.string   :player_name
      t.string   :player_steam_id
      t.string   :player_team

      t.string   :target_name
      t.string   :target_steam_id
      t.string   :target_team

      t.string   :cap_number
      t.string   :cap_name

      #chat
      t.text     :message
      #unknown events stored here
      t.text     :unknown

      t.string   :team
      t.string   :score

      #healing
      t.integer  :value

      #item pickup
      t.string   :item

      #role change
      t.string   :role

      #round length
      t.integer  :length

      #suicide
      t.string   :method
      t.timestamps
    end

    add_index :stats_events, :log_line_id
    add_index :stats_events, :match_id
    add_index :stats_events, :event_type
    add_index :stats_events, :time
    add_index :stats_events, :created_at
  end

  def down
    drop_table :stats_events
  end
end
