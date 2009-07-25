class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all
  protect_from_forgery :secret => '6af94d4fadc2a02cb2692db0af47f2b9'
  filter_parameter_logging :password

  before_filter :set_time_zone

  helper_method :commentable_url

  protected

  def set_time_zone
    Time.zone = logged_in? ? current_user.time_zone : 'Mexico City'
  end

  def pagination_options(options = {})
    options.reverse_merge(:page => params[:page], :order => 'created_at DESC', :per_page => 10)
  end

  def self.default_tinymce_options(options = {})
    {:only => [:new, :create, :edit, :update],
      :options => {
        :theme => 'advanced',
        :language => 'es',
        :plugins => ['safari', 'xhtmlxtras', 'fullscreen', 'advimage'],
        :theme_advanced_buttons3_add => '|,cite,ins,del,abbr,acronym,|,fullscreen',
        :button_tile_map => true,
        :external_image_list_url => '/uploads.js',
        :browsers => 'msie,gecko,opera'
      }
    }.merge(options)
  end

  def commentable_url(comment, options = {})
    case comment.commentable_type
    when 'Article'
      article_url(comment.commentable.permalink, options)
    when 'New'
      news_url(comment.commentable, options)
    when 'App'
      app_url(comment.commentable, options)
    end + "#comment-#{comment.id}"
  end
end
