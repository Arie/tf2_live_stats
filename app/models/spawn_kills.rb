class SpawnKills

  attr_accessor :round, :max_players

  delegate :player_name, :player_color, :to => :round

  def initialize(round)
    @round = Round.new(round)
  end

  def kills
    round.events.kill.select([:id, :created_at, :match_id, :time, :player_name, :player_steam_id, :player_team, :target_name, :target_steam_id, :target_team, :item, :customkill])
  end

  def spawns
    round.events.spawn.select([:id, :created_at, :match_id, :time, :player_name, :player_steam_id, :player_team, :item])
  end

  def as_json(options = {})
    stats_round = { created_at: round.round_start.time, score: round.score, duration: round.duration }
    { spawns: spawns, kills: kills, round: stats_round }
  end

end
