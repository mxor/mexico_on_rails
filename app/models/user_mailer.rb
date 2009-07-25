class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject += 'Por favor activa tu cuenta'
    @body[:url]  = "http://#{@host}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject += 'Tu cuenta ha sido activada!'
    @body[:url]  = "http://#{@host}/login"
  end

  def spam_notification(user, comment)
    setup_email(user)
    @subject += 'Un comentario ha sido marcado como spam'
    @body[:url] = "http://#{@host}/comments"
    @body[:comment] = comment
  end

  def comment_notification(user, comment)
    setup_email(user)
    @subject += 'Nuevo comentario'
    @body[:url] = "#{article_url(comment.commentable.permalink, :host => @host)}#comment-#{comment.id}"
    @body[:comment] = comment
  end

  def message_notification(message)
    setup_email(message.recipient)
    @subject += 'Tienes un nuevo mensaje'
    @body[:sender] = message.author.login
    @body[:body] = message.body
    @body[:url] = reply_message_url(message, :host => @host)
  end

  def password_reset_notification(user)
    setup_email(user)
    @subject += 'Reseteo de contraseña'
    @body[:url] = "http://#{@host}/reset/#{user.reset_code}"
  end
  
  protected
  
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "mxor@mexicoonrails.com.mx"
    @subject     = "[mxor] "
    @sent_on     = Time.now
    @body[:user] = user
    @body[:signature] = "---\nMéxico On Rails\nEvangelizando a México con Ruby on Rails\nhttp://mexicoonrails.com.mx"
    @host = 'mexicoonrails.com.mx'
  end
end
