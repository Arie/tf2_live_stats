class AddIndexToPlayerSteamId < ActiveRecord::Migration
  def change
    add_index :stats_events, :player_steam_id
  end
end
