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
end
