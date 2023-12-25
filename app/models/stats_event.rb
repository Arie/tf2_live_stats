# frozen_string_literal: true
class StatsEvent < ActiveRecord::Base

  include Delay

  attr_accessible :time, :event_type, :player_name, :player_steam_id, :player_team, :target_name
  attr_accessible :target_steam_id, :target_team, :cap_number, :cap_name, :message, :unknown
  attr_accessible :team, :score, :value, :item, :role, :length, :method, :log_line_id, :match_id
  attr_accessible :weapon, :customkill, :healing, :ubercharge, :created_at, :airshot

  belongs_to :log_line
  belongs_to :match

  default_scope { delayed.in_match }

  def self.in_match(match_id = RequestStore.store[:match_id])
    where('stats_events.match_id = ?', match_id)
  end

  def self.ordered
    order("stats_events.id DESC")
  end

  def self.on_or_after(stats_event)
    where('stats_events.id >= ?', stats_event.id)
  end

  def self.since(stats_event)
    where('stats_events.id > ?', stats_event.id)
  end

  def self.before(stats_event)
    where('stats_events.id <= ?', stats_event.id)
  end

  def self.rounds
    round_win
  end

  def self.last_round
    if round_win.last.id < match_end.last.id
      for_round(match_end.last)
    else
      for_round(round_win.last)
    end
  end

  def self.between(start_event, end_event)
    since(start_event).before(end_event)
  end

  def self.for_round(round_win)
    round_start = self.round_start.before(round_win).first
    if round_start
      between(round_start, round_win)
    else
      where('1 = 0')
    end
  end

  def self.build_from_event(event, log_line)
    attributes = {}

    attributes[:log_line_id]  = log_line.id
    attributes[:match_id]     = log_line.match_id

    attributes[:time] = event.try(:time)
    attributes[:event_type] = event.class.to_s

    if player = event.try(:player)
      attributes[:player_name]      = player.name
      attributes[:player_steam_id]  = player.steam_id
      attributes[:player_team]      = player.team
    end
    if target = event.try(:target)
      attributes[:target_name]      = target.name
      attributes[:target_steam_id]  = target.steam_id
      attributes[:target_team]      = target.team
    end

    attributes[:cap_number] = event.try(:cap_number)
    attributes[:cap_name]   = event.try(:cap_name)

    attributes[:message]    = event.try(:message)
    attributes[:unknown]    = event.try(:unknown)

    attributes[:team]       = event.try(:team)
    attributes[:score]      = event.try(:score)

    attributes[:value]      = event.try(:value)

    attributes[:item]       = event.try(:item)

    attributes[:role]       = event.try(:role)

    attributes[:length]     = event.try(:length)

    attributes[:method]     = event.try(:method)

    attributes[:weapon]     = event.try(:weapon)
    attributes[:customkill] = event.try(:customkill)
    attributes[:airshot]    = event.try(:airshot)

    attributes[:healing]    = event.try(:healing)
    attributes[:ubercharge] = event.try(:ubercharge)


    new(attributes)
  end
  #
  #dynamically generate the class methods to find all different events
  class << self
    TF2LineParser::Events::Event.types.each do |type|
      define_method type.to_s.split("::").last.underscore.to_sym do
        where(:event_type => "#{type}")
      end
    end
  end
end
