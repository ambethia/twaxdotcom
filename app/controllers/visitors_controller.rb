class VisitorsController < ApplicationController
  def index
  end

  def placeholder
    render layout: false
  end

  def try_now_path
    current_user ? faxes_path : signin_path
  end

  helper_method :try_now_path
end
