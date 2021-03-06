class SentController < ApplicationController
  before_filter :login_required

  def index
    @messages = current_user.sent_messages.paginate(pagination_options)
  end

  def show
    @message = current_user.sent_messages.find(params[:id])
  end

  def new
    @message = current_user.sent_messages.build
  end

  def create
    @message = current_user.sent_messages.build(params[:message])

    if @message.save
      flash[:notice] = 'Mensaje enviado.'
      redirect_to sent_index_path
    else
      render :action => 'new'
    end
  end
end
