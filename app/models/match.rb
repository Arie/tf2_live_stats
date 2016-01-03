# frozen_string_literal: true
class Match < ActiveRecord::Base

  attr_accessible :host, :rcon, :secret

  before_create :generate_secret
  after_create :configure_server

  has_many :stats_events
  has_many :log_lines

  def self.from_file(file)
    @match = Match.create!
    transaction do
      file.read.lines.each do |line|
        LogLine.create!(:line => line, :match => @match)
      end
    end
  end

  def generate_secret
    self[:secret] = self[:secret].presence || rand(10**32)
  end

  def configure_server
    unless rcon.blank?
      console = condenser(ip, port || 27015)
      console.rcon_auth(rcon)
      console.rcon_exec("sv_logsecret \"#{secret}\"; logaddress_add \"fakkelbrigade.eu:20001\"; say Live stats configured...; livelogs_force_logsecret 0")
    end
  end

  def ip
    @ip ||= host.split(":").first
  end

  def port
    @port ||= host.split(":").last
  end

  private

  def condenser(ip, port)
    SteamCondenser::Servers::SourceServer.new(ip, port.to_i)
  end

end
