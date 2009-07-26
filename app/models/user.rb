require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  has_many :articles, :order => 'created_at DESC'
  has_many :uploads
  has_many :apps
  has_many :sent_messages, :class_name => 'Message', :foreign_key => 'author_id'
  has_many :received_messages, :class_name => 'MessageCopy', :foreign_key => 'recipient_id'
  has_many :folders
  has_many :feeds, :class_name => "FeedUrl"

  validates_presence_of :login
  validates_length_of :login, :within => 3..20
  validates_uniqueness_of :login
  validates_format_of :login, :with => Authentication.login_regex
  validates_exclusion_of :login, :in => %w(admin administrador staff administrator)

  validates_length_of :name, :maximum => 100, :allow_nil => true

  validates_presence_of :email
  validates_length_of :email, :within => 6..100 #r@a.wk
  validates_uniqueness_of :email
  validates_format_of :email, :with => Authentication.email_regex

  validates_format_of :public_email, :with => Authentication.email_regex, :if => lambda {|p| !p.public_email.blank?}
  validates_format_of :msn, :with => Authentication.email_regex, :if => lambda {|p| !p.msn.blank?}

  before_create :make_activation_code
  before_create :build_default_folders
  before_save :add_protocol_to_url_and_sanitize_about

  named_scope :active, :conditions => {:activation_code => nil}

  ajaxful_rater
  
  attr_accessible :login, :email, :name, :password, :password_confirmation, :time_zone, :weblog, :public_email, :msn, :about,
    :github, :wwr, :linkedin, :twitter, :os, :text_editor, :feed_urls
    
  def feed_urls=(urls)
    urls.split("\r\n").each do |url|
      feeds.build(:url => url) unless FeedUrl.find_by_url(url)
    end
  end
  
  # fake attr reader for form
  def feed_urls
    nil
  end
  
  def feed_urls_list
    feeds.map(&:url)
  end

  def make_reset_code
    @reseted = true
    self.reset_code = self.class.make_token
    save(false)
  end

  def delete_reset_code
    self.reset_code = nil
    save(false)
  end

  def recently_reseted?
    @reseted
  end

  def inbox
    folders.find_by_name('Bandeja de entrada')
  end

  def trash
    folders.find_by_name('Eliminados')
  end

  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  protected

  def build_default_folders
    ['Bandeja de entrada', 'Eliminados'].each do |folder|
      folders.build(:name => folder)
    end
  end
    
  def make_activation_code
    self.activation_code = self.class.make_token
  end

  def add_protocol_to_url_and_sanitize_about
    self.weblog = "http://#{weblog}" unless weblog.blank? || weblog =~ /\Ahttps?:\/\/.*/i
    self.about = ActionController::Base.helpers.sanitize(about) unless about.blank?
  end
end
