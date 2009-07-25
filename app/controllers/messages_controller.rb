class MessagesController < ApplicationController
  before_filter :login_required
  
  def show
    @message = find_message
  end

  def reply
    @original = find_message
    subject = @original.subject.sub(/^(Re: )?/, "Re: ")
    body = @original.body.gsub(/^/, "> ")
    @message = current_user.sent_messages.build(:to => [@original.author.id], :subject => subject, :body => body)
    render :template => 'sent/new'
  end

  def forward
    @original = find_message

    subject = @original.subject.sub(/^(Fwd: )?/, "Fwd: ")
    body = @original.body.gsub(/^/, "> ")
    @message = current_user.sent_messages.build(:subject => subject, :body => body)
    render :template => "sent/new"
  end

  def destroy
    switch_deleted true
  end

  def restore
    switch_deleted false
  end

  private

  def switch_deleted(deleted)
    @message = find_message
    @message.update_attributes(:folder_id => (deleted ? current_user.trash.id : current_user.inbox.id), :deleted => deleted)
    flash[:notice] = "Mensaje #{deleted ? 'eliminado' : 'restaurado'}."
    redirect_to inbox_path
  end

  def find_message
    current_user.received_messages.find(params[:id])
  end
end
