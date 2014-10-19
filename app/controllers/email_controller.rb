class EmailController < ApplicationController
  def index
    @emails = InboundMail.all
  end

  def show
    @email = InboundMail.find params[:id]
    render text: @email['data']['msg']['html']
  end
end
