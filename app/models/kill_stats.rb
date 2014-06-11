class KillStats

  attr_accessor :round, :max_players

  delegate :player_color, :player_name, :to => :round

  def initialize(round, max_players = 5)
    @round = Round.new(round)
    @max_players = max_players
  end

  def stats
    @stats ||= round.events.kill.group(:player_steam_id).count.sort_by { |k,v| v }.reverse
  end

  def chart_data
    data = stats.collect do |steam_id, kills|
      [player_name(steam_id), kills]
    end
    data
  end

  def chart
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Player')
    data_table.new_column('number', 'Kills')
    data_table.add_rows(chart_data)
    option = { width: 375, height: 240, title: 'Kills', colors: ["black"], legend: {position: 'none'}, vAxis: {minValue:0, format:'#'} }
    GoogleVisualr::Interactive::BarChart.new(data_table, option)
  end

  def as_json(options = {})
    kill_stats = stats.collect do |steam_id, stat|
                                { player_name: round.player_name(steam_id),
                                  player_steam_id: steam_id,
                                  team: round.player_color(steam_id),
                                  value: stat
                                }
                              end[0...max_players]
    stats_round = { created_at: round.round_start.time, score: round.score }
    { stats: kill_stats, round: stats_round }
  end

end
