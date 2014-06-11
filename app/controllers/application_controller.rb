class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_delay

  def set_delay(delay = params[:delay])
    if delay
      RequestStore.store[:delay] = delay.to_i.seconds
    end
  end

end

