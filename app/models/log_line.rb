# frozen_string_literal: true
class LogLine < ActiveRecord::Base

  include Delay

  attr_accessible :line, :match_id, :match
  after_create :create_stats_event

  has_one :stats_event
  belongs_to :match

  default_scope { delayed.in_match }

  def self.in_match(match_id = RequestStore.store[:match_id])
    where('log_lines.match_id = ?', match_id)
  end

  def self.ordered
    order('log_lines.id DESC')
  end

  def create_stats_event
    StatsEvent.build_from_event(event, self).save
  end

  def event
    @event ||= TF2LineParser::Parser.new(line).parse
  end

end
