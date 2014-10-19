class HelpController < ApplicationController
  layout false

  helper_method :page_name

  private

  def page_name
    params[:page] && params[:page].downcase || 'default'
  end
end
