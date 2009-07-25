class CommentsController < ApplicationController
  before_filter :login_required, :except => [:index, :create]
  before_filter :require_admin, :except => [:index, :create]
  before_filter :find_comment, :only => [:edit, :update, :destroy, :approve, :disapprove]

  def index
    @approved_comments = Comment.recent(10)
    @rejected_comments = Comment.rejected if logged_in? && current_user.admin?
  end

  def create
    commentable_type, commentable_id = request.env['HTTP_REFERER'].scan(/http:\/\/.*?\/(\w+)\/(.*)?/).flatten

    commentable = case commentable_type
    when 'articles'
      Article.find_by_permalink!(commentable_id)
    when 'news'
      New.find(commentable_id)
    when 'apps'
      App.find(commentable_id)
    else
      nil
    end

    if commentable.respond_to?(:comments)
      @comment = commentable.comments.build(params[:comment])
      @comment.request = request

      render :update do |page|
        if @comment.save
          if @comment.approved?
            page.insert_html :bottom, :comments, :partial => @comment
            page.visual_effect :appear, "comment-#{@comment.id}"
            page.hide :remote_errors
          else
            page.replace_html :remote_errors, 'Desafortunadamente tu comentario ha sido marcado como spam.' +
              'Será revisado y publicado en caso de no serlo.'
            page.show :remote_errors
          end
          page['new_comment'].reset
        else
          page.replace :remote_errors, :partial => 'shared/remote_errors', :object => @comment.errors.full_messages
          page.show :remote_errors
        end
      end
    else
      render :update do |page|
        page.replace_html :remote_errors, 'Hubo un error al agregar tu comentario. Intenta de nuevo'
        page.show :remote_errors
      end
    end
  end

  def edit
  end

  def update
    if @comment.update_attributes(params[:comment])
      flash[:notice] = 'Comentario actualizado.'
      redirect_to commentable_url(@comment)
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @comment.destroy
      flash[:notice] = 'Comentario eliminado.'
    else
      flash[:error] = "Ocurrió un problema al tratar de eliminar el comentario. Intenta de nuevo."
    end
    redirect_to :back
  end

  def destroy_multiple
    Comment.destroy(params[:comment_ids])
    flash[:notice] = 'Comentarios eliminados.'
    redirect_to comments_path
  end

  def approve
    flash[:notice] = 'Comentario aprobado.'
    swap_approved true
  end

  def disapprove
    flash[:notice] = 'Comentario marcado como spam.'
    swap_approved false
  end

  private

  def swap_approved(approved)
    @comment.approved = approved
    @comment.save
    redirect_to :back
  end

  def find_comment
    @comment ||= Comment.find(params[:id])
  end

  def require_admin
    redirect_to root_path unless current_user.admin?
  end
end
