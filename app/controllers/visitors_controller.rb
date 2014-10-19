class VisitorsController < ApplicationController
  def index
    @video_url = Hack.get('video_url')
  end

  def placeholder
    render layout: false
  end

  def try_now_path
    current_user ? faxes_path(format: 'cfm') : signin_path
  end

  helper_method :try_now_path
end
