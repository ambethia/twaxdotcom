class WebhooksController < ApplicationController

  def recieve
  end

  def inbound_mail
    params[:mandrill_events].each do |event|
      InboundMail.create!(data: event)
    end
  end
end
