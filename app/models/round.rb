class Round

  attr_accessor :event, :round_start, :round_end, :delay, :match_id

  delegate :id, :to => :event, :prefix => true

  def initialize(event, delay = 90.seconds)
    @event = event
    @delay = delay
  end

  def self.current
    if last_round_start = stats_event_scope.round_start.first
      last_round_start# if round.round_end.nil?
    end
  end

  def round_start
    @round_start ||= begin
                      if event
                        Round.stats_event_scope.round_start.before(event).first || Round.stats_event_scope.before(event).first
                      end
                     end
  end

  def round_end
    @round_end ||= begin
                    if round_start
                      Round.stats_event_scope.round_win.since(round_start).last || Round.stats_event_scope.round_stalemate.since(round_start).last || Round.stats_event_scope.match_end.since(round_start).first
                    end
                   end
  end

  def in_progress?
    round_end.nil?
  end

  def duration
    if round_end && round_length = StatsEvent.since(event).round_length.first
      (round_length.length.to_f / 60.0).round(1)
    elsif round_start
      ((round_start.time - event.time) / 60.0).round(1)
    end
  end

  def score
    @score ||= begin
                if round_end
                  StatsEvent.since(event).current_score.first(2).map do |event|
                    "#{event.team}: #{event.score}"
                  end.join(" - ")
                else

                end
               end
  end

  def events
    @events ||= begin
                  if in_progress?
                    Round.stats_event_scope.since(round_start).delayed(delay)
                  else
                    Round.stats_event_scope.between(round_start, round_end)
                  end
                end
  end

  def players
    @players ||= events.ordered.select([:player_steam_id, :player_team, :player_name]).uniq
  end

  def player_color(steam_id, match_id = RequestStore.store[:match_id])
    Rails.cache.fetch "team_#{event_id}_#{steam_id}_#{match_id}" do
      players.find_by_player_steam_id(steam_id).player_team.downcase
    end
  end

  def player_name(steam_id, match_id = RequestStore.store[:match_id])
    Rails.cache.fetch "name_#{steam_id}_#{match_id}" do
      players.find_by_player_steam_id(steam_id).player_name
    end
  end

  def self.stats_event_scope
    StatsEvent.ordered
  end

end
