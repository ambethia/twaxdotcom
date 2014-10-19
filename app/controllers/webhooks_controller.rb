class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def receive
    fax = JSON.parse params[:fax]
    Fax.handle_incoming_fax({
      phaxio_id: fax[:id],
      metadata: params[:metadata],
      fax_number: fax[:from_number],
      file: params[:filename],
      payload: fax,
    })
  end

  def inbound_mail
    if params[:mandrill_events]
      JSON.parse(params[:mandrill_events]).each do |event|
        InboundMail.create!(data: event)
      end
    end

    head :ok
  end
end
