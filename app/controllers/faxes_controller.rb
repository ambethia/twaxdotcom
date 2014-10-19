class FaxesController < ApplicationController
  before_filter :authenticate_user!, except: [:show]

  def index
    @faxes = current_user.faxes
  end

  def new
    render :new, layout: false
  end

  def show
    @fax = Fax.find params[:id]
    @page_url = @fax.pages.first.file.url
  end
end
