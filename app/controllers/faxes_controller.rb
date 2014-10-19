class FaxesController < ApplicationController
  before_filter :check_for_current_user

  def index
    @faxes = current_user.faxes
  end

  def new
    render :new, layout: false
  end

  def show
    @fax = current_user.faxes.find params[:id]
  end
end
