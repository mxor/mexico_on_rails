class MailboxController < ApplicationController
  before_filter :login_required

  def index
    @folder = current_user.inbox
    show
    render :action => 'show'
  end

  def show
    @folder ||= current_user.folders.find(params[:id])
    @messages = @folder.messages.paginate(pagination_options :include => :message, :order => 'messages.created_at DESC')
  end

  def trash
    @folder = current_user.trash
    show
    render :action => 'show'
  end
end
