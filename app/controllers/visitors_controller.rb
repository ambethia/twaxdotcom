class VisitorsController < ApplicationController
  def index
    render layout: 'placeholder'
  end

  %i(real help help_left help_right).each do |action|
    define_method action do
    end
  end
end
