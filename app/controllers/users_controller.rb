class UsersController < ApplicationController
  before_filter :login_required, :only => [:edit, :update]
  uses_tiny_mce default_tinymce_options :only => [:edit, :update]

  def index
    @users ||= User.active.paginate(pagination_options :per_page => 35)
  end

  def show
    @user = User.find_by_login!(params[:id], :include => :articles)
    @user_articles = @user.articles.recent
  end
  
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Gracias por darte de alta! Pronto recibirás un correo para confirmar tu cuenta."
    else
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Tu registro está completo! Ahora puedes %s a tu cuenta" % @template.link_to('entrar', login_path)
      redirect_to login_path
    when params[:activation_code].blank?
      flash[:error] = "El código de activación no se encontró. Por favor revisa la URL del correo de activación."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "No se encontró ningún usuario con ese código de activación, puede que ya esté activado."
      redirect_back_or_default('/')
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    params[:remove_feeds].each do |url|
      feed = @user.feed_articles.find_by_feed_url(url)
      feed.destroy if feed
    end if params[:remove_feeds]
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "Tu perfil se ha actualizado."
      redirect_to profile_path(@user.login)
    else
      render :action => 'edit'
    end
  end

  def forgot
    if request.post?
      if (user = User.find_by_email(params[:email]))
        user.make_reset_code
        flash[:notice] = 'Se ha enviado un correo con las instrucciones a seguir.'
        redirect_to root_path
      else
        flash[:error] = 'No existe esa dirección de correo.'
        redirect_to login_path
      end
    end
  end

  def reset
    logout_keeping_session!
    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].blank?
    if @user
      @user.delete_reset_code
      self.current_user = @user
      render :action => 'edit'
    else
      flash[:error] = 'Código incorrecto. Por favor sigue el enlace del correo.'
      redirect_to login_path
    end
  end
end
