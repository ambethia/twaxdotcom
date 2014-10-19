class VisitorsController < ApplicationController
  def index
    @video_url = Hack.get('video_url')
  end

  def placeholder
    render layout: false
  end
end
