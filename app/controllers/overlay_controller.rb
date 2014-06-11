class OverlayController < WebsocketRails::BaseController

  before_filter :set_delay
  before_filter :set_match

  def current_damage
    send_message :current_damage, DamageStats.new(current_round, 12)
  end

  def current_kills
    send_message :current_kills,  KillStats.new(current_round, 12)
  end

  def last_damage
    send_message :last_damage,    DamageStats.new(last_round, 12)
  end

  def last_kills
    send_message :last_kills,     KillStats.new(last_round, 12)
  end

  def spawn_kills
    send_message :spawn_kills,    SpawnKills.new(current_round)
  end

  private

  def current_round
    @current_round ||= Round.current
  end

  def last_round
    @last_round ||= rounds.first
  end

  def rounds
    @rounds ||= StatsEvent.ordered.rounds
  end

  def set_match
    RequestStore.store[:match_id] = message[:match_id].to_i
    @match = Match.find(message[:match_id])
  end

  def set_delay(delay = message[:delay])
    if delay
      RequestStore.store[:delay] = delay.to_i.seconds
    end
  end

end
