class DamageStats

  attr_accessor :round, :max_players

  delegate :player_name, :player_color, :to => :round

  def initialize(round, max_players = 5)
    @round = Round.new(round)
    @max_players = max_players
  end

  def stats
    @stats ||= round.events.damage.group(:player_steam_id).sum(:value).sort_by { |k,v| v }.reverse
  end

  def chart_data
    data = stats.collect do |steam_id, damage|
      [player_name(steam_id), damage]
    end
    data
  end

  def chart
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Players' )
    data_table.new_column('number', 'Damage')
    data_table.add_rows(chart_data)
    option = { width: 375, height: 240, title: 'Damage', colors: ["green"], legend: {position: 'none'} }
    GoogleVisualr::Interactive::BarChart.new(data_table, option)
  end

  def as_json(options = {})
    damage_stats = stats.collect do |steam_id, stat|
                                { player_name: round.player_name(steam_id),
                                  player_steam_id: steam_id,
                                  team: round.player_color(steam_id),
                                  value: stat
                                }
                              end[0...max_players]
    stats_round = { created_at: round.round_start.time, score: round.score, duration: round.duration }
    { stats: damage_stats, round: stats_round }
  end

end
