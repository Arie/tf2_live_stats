# frozen_string_literal: true
class MatchesController < ApplicationController
  http_basic_authenticate_with :name => "HTTP_USERNAME", :password => "HTTP_PASSWORD"

  before_filter :set_match_id, :only => :show

  def new
    @match = Match.new(:host => params[:host], :secret => params[:logsecret], :rcon => params[:rcon])
  end

  def show
    set_delay(0)
    @match = Match.find(params[:id])
  end

  def create
    @match = Match.new(params[:match])
    if @match.save
      redirect_to match_path(@match)
    else
      render :new
    end
  end

  def edit
    @match = Match.find(params[:id])
  end

  def update
    @match = Match.find(params[:id])
    if @match.update_attributes(params[:match])
      redirect_to match_path(@match)
    else
      render :edit
    end
  end

  private

  def set_match_id
    RequestStore.store[:match_id] = params[:id].to_i
    @match = Match.find(params[:id])
  end

end
