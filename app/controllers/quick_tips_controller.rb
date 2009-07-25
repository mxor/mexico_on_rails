class QuickTipsController < ApplicationController
  before_filter :login_required
  before_filter :require_admin
  before_filter :find_quick_tip, :only => [:edit, :update, :destroy]
  uses_tiny_mce default_tinymce_options

  def index
    @quick_tips = QuickTip.all
  end

  def new
    @quick_tip = QuickTip.new
  end

  def create
    @quick_tip = QuickTip.new(params[:quick_tip])
    if params[:publish] && @quick_tip.save
      flash[:notice] = 'Tip creado.'
      redirect_to quick_tips_path
    else
      @quick_tip.content = params[:quick_tip][:content] if params[:preview]
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @quick_tip.update_attributes(params[:quick_tip])
      flash[:notice] = 'Tip actualizado.'
      redirect_to quick_tips_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @quick_tip.destroy
      flash[:notice] = 'Tip eliminado.'
    else
      flash[:error] = 'Hubo un problema al eliminar el tip. Intenta de nuevo.'
    end
    redirect_to quick_tips_path
  end

  private

  def require_admin
    redirect_to root_path unless current_user.admin?
  end

  def find_quick_tip
    @quick_tip ||= QuickTip.find(params[:id])
  end
end
