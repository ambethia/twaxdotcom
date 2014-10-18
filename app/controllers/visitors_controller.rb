class VisitorsController < ApplicationController
  def index
  end

  def placeholder
    render layout: false
  end

  %i(real help help_left help_right).each do |action|
    define_method action do
    end
  end

  def try_now_path
    current_user ? faxes_path : signin_path
  end

  helper_method :try_now_path
end
