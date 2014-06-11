class AddMedicDeathAndKillInformationFieldsToStatsEvents < ActiveRecord::Migration
  def change
    add_column :stats_events, :healing, :integer
    add_column :stats_events, :ubercharge, :boolean
    add_column :stats_events, :weapon, :string
    add_column :stats_events, :customkill, :string
  end
end
