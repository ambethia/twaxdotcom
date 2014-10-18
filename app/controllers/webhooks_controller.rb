class WebhooksController < ApplicationController
  def recieve
    Fax.handle_incoming_fax({
      phaxio_id: params[:fax][:id],
      metadata: params[:metadata],
      fax_number: params[:fax][:from_number],
      cost: params[:fax][:cost],
      payload: params[:fax]
    })
  end
end
