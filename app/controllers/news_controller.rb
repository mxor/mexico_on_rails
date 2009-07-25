class NewsController < ApplicationController
  before_filter :login_required, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :redirect_unless_admin, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :find_new, :only => [:show, :edit, :update, :destroy]
  uses_tiny_mce default_tinymce_options

  def index
    @news = New.paginate(pagination_options)
  end

  def show
    @new_comments = @new.comments.approved.paginate(pagination_options :order => 'created_at')
  end

  def new
    @new = New.new
  end

  def edit
  end

  def create
    @new = New.new(params[:new])

    if params[:publish] && @new.save
      flash[:notice] = 'Noticia publicada.'
      redirect_to news_path(@new)
    else
      render :action => 'new'
    end
  end

  def update
    if params[:publish] && @new.update_attributes(params[:new])
      flash[:notice] = 'Noticia actualizada.'
      redirect_to news_path(@new)
    else
      @new.content = params[:new][:content] if params[:preview]
      render :action => 'edit'
    end
  end

  def destroy
    if @new.destroy
      flash[:notice] = 'Noticia eliminada.'
      redirect_to news_index_path
    else
      flash[:error] = 'No se pudo eliminar la noticia. Intentalo de nuevo.'
      redirect_to news_path(@new)
    end
  end
  
  private

  def redirect_unless_admin
    redirect_to news_index_path unless current_user.admin?
  end

  def find_new
    @new ||= New.find(params[:id])
  end
end
