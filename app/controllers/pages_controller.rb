class PagesController < ApplicationController
  http_basic_authenticate_with :name => "live", :password => "vtvonly", :except => :public

  before_filter :set_match_id
  caches_action :stats,           :cache_path => Proc.new {|c| c.request.url }, :expires_in => 2.seconds
  caches_action :current_damage,  :cache_path => Proc.new {|c| "#{params[:match_id].to_i}_#{params[:action]}_#{params[:delay]}" }, :expires_in => 1.second
  caches_action :current_kills,   :cache_path => Proc.new {|c| "#{params[:match_id].to_i}_#{params[:action]}_#{params[:delay]}" }, :expires_in => 1.second
  caches_action :last_damage,     :cache_path => Proc.new {|c| "#{params[:match_id].to_i}_#{params[:action]}_#{params[:delay]}" }, :expires_in => 1.second
  caches_action :last_kills,      :cache_path => Proc.new {|c| "#{params[:match_id].to_i}_#{params[:action]}_#{params[:delay]}" }, :expires_in => 1.second
  caches_action :public,          :cache_path => Proc.new {|c| c.request.url }, :expires_in => 5.seconds

  def public
    set_delay(110)
    @relevant_log_lines = relevant_log_lines.limit(500)
    render "stats"
  end

  def stats
    @relevant_log_lines = relevant_log_lines.limit(500)
  end

  def streamer_stats
    set_delay(params[:delay] || 70)
    respond_to do |format|
      @relevant_log_lines = relevant_log_lines_for_streamer.limit(150)
      format.html
      format.json do
        render :json => StatsEvent.where(:log_line_id => @relevant_log_lines.pluck(:id))
      end
    end
  end

  def external
    render :json => ExternalStats.new(relevant_log_lines_for_streamer.limit(100)).to_json
  end

  def current_damage
    render :json => DamageStats.new(current_round).to_json
  end

  def current_kills
    render :json => KillStats.new(current_round).to_json
  end

  def last_damage
    render :json => DamageStats.new(last_round).to_json
  end

  def last_kills
    render :json => KillStats.new(last_round).to_json
  end

  def overlay
  end

  def log
    @log_lines = LogLine.ordered
  end

  private

  def set_match_id
    RequestStore.store[:match_id] = params[:match_id].to_i
    @match = Match.find(params[:match_id])
  end

  def current_round
    @current_round ||= Round.current
  end
  helper_method :current_round

  def relevant_log_lines
    @relevant_log_lines ||= LogLine.ordered.joins(:stats_event).where('stats_events.event_type NOT IN (?)', irrelevant_event_types)
  end

  def relevant_log_lines_for_streamer
    @relevant_log_lines ||= LogLine.ordered.joins(:stats_event).where('stats_events.event_type IN (?)', relevant_event_types_for_caster)
  end

  def rounds
    @rounds ||= StatsEvent.ordered.rounds
  end
  helper_method :rounds

  def last_round
    @last_round ||= rounds.first
  end
  helper_method :last_round

  def relevant_event_types_for_caster
    [ "TF2LineParser::Events::ChargeDeployed",
      "TF2LineParser::Events::Airshot",
      "TF2LineParser::Events::CurrentScore", "TF2LineParser::Events::MatchEnd",
      "TF2LineParser::Events::MedicDeath",   "TF2LineParser::Events::PointCapture",
      "TF2LineParser::Events::RoundStart",   "TF2LineParser::Events::Kill", ]
  end

  def irrelevant_event_types
    ["NilClass", "TF2LineParser::Events::Assist", "TF2LineParser::Events::CaptureBlock",
     "TF2LineParser::Events::Damage", "TF2LineParser::Events::Heal", "TF2LineParser::Events::PickupItem",
     "TF2LineParser::Events::Spawn", "TF2LineParser::Events::Unknown"]
  end

end
