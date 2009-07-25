class SessionsController < ApplicationController
  def new
    session[:return_to] = request.env['HTTP_REFERER'] if request.env['HTTP_REFERER']
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
      flash[:notice] = "Has iniciado sesión correctamente."
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "Has cerrado tu sesión correctamente. %s" % @template.link_to('Login', login_path)
    redirect_to(request.env['HTTP_REFERER'] ? :back : '/')
  end

  protected
  # Track failed login attempts
  def note_failed_signin
    flash.now[:error] = "El usuario o la contraseña son incorrectos."
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
