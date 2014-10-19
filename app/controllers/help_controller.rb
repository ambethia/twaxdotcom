class HelpController < ApplicationController
  layout false

  def index
  end

  def page_name
    params[:page] && params[:page].downcase || 'default'
  end

  helper_method :page_name
end
