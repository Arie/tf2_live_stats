class CevoMatchesController < ApplicationController

  protect_from_forgery except: :create

  def create
    Rails.logger.info "=" * 200
    Rails.logger.info "CEVO MATCH"
    Rails.logger.info request.headers.inspect
    Rails.logger.info "=" * 200
  end
end
