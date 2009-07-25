class AppsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_owner_app, :only => [:edit, :update, :destroy]
  uses_tiny_mce default_tinymce_options
  
  def index
    @apps ||= if params[:user_id]
      @user = User.find_by_login!(params[:user_id], :include => :apps)
      @user.apps
    else
      App
    end.paginate(pagination_options)
  end

  def show
    @app = App.find(params[:id])
    @app_comments = @app.comments.approved.paginate(pagination_options :order => 'created_at')
  end

  def new
    @app = App.new
  end

  def edit
  end

  def create
    @app = current_user.apps.build(params[:app])

    if @app.save
      flash[:notice] = 'La aplicación ha sido añadida al repositorio.'
      redirect_to @app
    else
      render :action => 'new'
    end
  end

  def update
    if @app.update_attributes(params[:app])
      flash[:notice] = 'Aplicación actualizada.'
      redirect_to @app
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @app.destroy
      flash[:notice] = 'Se ha eliminado la aplicación.'
      redirect_to apps_path
    else
      flash[:error] = 'Hubo un error al tratar de eliminar la aplicación. Intenta de nuevo'
      redirect_to @app
    end
  end

  private

  def find_owner_app
    @app ||= current_user.apps.find(params[:id])
  end
end
