# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "hpricot", :source => "http://code.whytheluckystiff.net"
  config.gem "RedCloth", :lib => "redcloth", :source => "http://code.whytheluckystiff.net"
  config.gem 'javan-whenever', :lib => false, :source => 'http://gems.github.com'
  config.gem "rss-client"
  config.time_zone = 'UTC'
  config.i18n.default_locale = :'es-MX'
  config.action_controller.session = {
    :session_key => '_mxor_session',
    :secret      => 'fc1936eb538d8bd716ea4acee8860ccd7afa286369a09d3f71f5dd7257ef47217cbd2de293bcb8e668407c0a19ad9305c9ad725c1f01323934a1be2d5d3d6b7d'
  }
  config.action_controller.session_store = :active_record_store
  config.active_record.timestamped_migrations = false
  config.active_record.observers = [:user_observer, :comment_observer, :message_copy_observer]
  config.action_view.sanitized_allowed_attributes = 'style'
end