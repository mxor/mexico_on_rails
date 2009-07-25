class SitemapPluginController < ActionController::Base
  layout 'sitemap_plugin'
  before_filter :check_sitemap_auth
  protect_from_forgery :secret => 'b9dc4e7e19101cd9577ae585fe7ff014ff5d550d62f98a02e01629251f'
  
  def check_sitemap_auth
    settings = SitemapSetting.find(:first)
    return unless settings && settings.username && settings.password
    authenticate_or_request_with_http_basic do |username, password|
      username == settings.username && password == settings.password
    end
  end
  
end