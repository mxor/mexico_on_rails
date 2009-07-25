class ArticlesController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_owner_article, :only => [:edit, :update, :destroy]
  uses_tiny_mce default_tinymce_options
  
  def index
    @articles ||= if params[:tag]
      Article.find_tagged_with(params[:tag])
    elsif params[:user_id]
      @user = User.find_by_login!(params[:user_id], :include => [:articles, :feed_articles])
      @user.articles
    else
      Article
    end.paginate(pagination_options)
    
    @feed_articles = if params[:user_id]
      @user.feed_articles
    else
      FeedArticle.all
    end.map(&:entries).flatten.sort_by(&:published_at).reverse[0...10]
  end

  def rate
    @article = Article.find(params[:id])
    msg = 'Gracias por tu calificación!'
    begin
      @article.rate(params[:stars], current_user)
    rescue
      msg = 'Hubo un error al tratar de calificar el artículo. Intenta de nuevo.'
    end
    id = "ajaxful-rating-article-#{@article.id}"
    render :update do |page|
      page.replace_html id, ratings_for(@article, :wrap => false)
      page.visual_effect :highlight, id, :endcolor => '#eeeeee'
      page.insert_html :bottom, id, msg
    end
  end


  def show
    @article = Article.find_by_permalink!(params[:id], :include => :comments)
    @article_comments = @article.comments.approved.paginate(pagination_options :order => 'created_at')
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(params[:article])
    
    if params[:publish] && @article.save
      flash[:notice] = 'Artículo publicado'
      redirect_to articles_path
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if params[:publish] && @article.update_attributes(params[:article])
      flash[:notice] = 'Articulo actualizado.'
      redirect_to article_path(@article.permalink)
    else
      if params[:preview]
        @article.excerpt = params[:article][:excerpt]
        @article.body = params[:article][:body]
      end
      render :action => 'edit'
    end
  end

  def destroy
    if @article.destroy
      flash[:notice] = 'Articulo eliminado.'
      redirect_to articles_path
    else
      flash[:error] = 'No se pudo eliminar el articulo. Intentalo de nuevo.'
      redirect_to article_path(@article.permalink)
    end
  end

  private

  def find_owner_article
    @article ||= current_user.articles.find(params[:id])
  end
end
