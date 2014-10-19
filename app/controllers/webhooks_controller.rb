class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def receive
    Fax.handle_incoming_fax({
      phaxio_id: params[:fax][:id],
      metadata: params[:metadata],
      fax_number: params[:fax][:from_number],
      cost: params[:fax][:cost],
      payload: params[:fax]
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
