class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def recieve
  end

  def inbound_mail
    if params[:mandrill_events]
      params[:mandrill_events].each do |event|
        InboundMail.create!(data: event)
      end
    end

    head :ok
  end
end
