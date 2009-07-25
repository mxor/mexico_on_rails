class PagesController < ApplicationController
  before_filter :find_page, :only => [:edit, :update, :destroy, :publish, :unpublish]
  before_filter :login_required, :except => :show
  before_filter :require_admin, :except => :show
  uses_tiny_mce default_tinymce_options
  
  def index
    @pages = Page.all(:order => 'position')
  end

  def show
    @page = Page.find_by_permalink!(params[:id])
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
    @page = Page.new(params[:page])

    if params[:publish] && @page.save
      flash[:notice] = 'Página creada.'
      redirect_to pages_path
    else
      @page.content = params[:page][:content] if params[:preview]
      render :action => 'new'
    end
  end

  def update
    if params[:publish] && @page.update_attributes(params[:page])
      flash[:notice] = 'Página actualizada.'
      redirect_to pages_path
    else
      @page.content = params[:page][:content] if params[:preview]
      render :action => 'edit'
    end
  end

  def destroy
    if @page.destroy
      flash[:notice] = 'Página eliminada.'
    else
      flash[:error] = 'Hubo un problema al tratar de eliminar la página. Intenta de nuevo.'
    end
    redirect_to pages_path
  end

  def sort
    params['page-list'].each_index do |i|
      item = Page.find(params['page-list'][i])
      item.position = i
      item.save
    end
    @pages = Page.all(:order => 'position')
    render :nothing => true
  end

  def publish
    swap_published true
  end

  def unpublish
    swap_published false
  end

  private

  def swap_published(published)
    redirect_to pages_path if @page.update_attributes(:published => published)
  end

  def require_admin
    redirect_to root_path unless current_user.admin?
  end

  def find_page
    @page ||= Page.find(params[:id])
  end
end
