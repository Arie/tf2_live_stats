class AddAirshotsToStatsEvents < ActiveRecord::Migration
  def change
    add_column :stats_events, :airshot, :boolean
  end
end
