class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true, :counter_cache => true

  validates_presence_of :name, :email, :content
  validates_format_of :email, :with => Authentication.email_regex, :if => lambda {|p| !p.email.blank?}
  
  attr_accessible :name, :email, :site_url, :content

  named_scope :approved, :conditions => {:approved => true}
  named_scope :rejected, :conditions => {:approved => false}

  before_save :textilize_content_and_add_protocol_to_url
  before_create :check_for_spam

  def self.recent(limit = 3, conditions = nil)
    find_all_by_approved(true, :limit => limit, :conditions => conditions, :order => 'created_at DESC')
  end

  def request=(request)
    self.user_ip = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer = request.env['HTTP_REFERER']
  end

  def recently_added?
    @recently_added
  end

  def commentable_name_or_title
    commentable.type == 'App' ? commentable.name : commentable.title
  end

  protected

  def check_for_spam
    self.approved = !Akismetor.spam?(akismet_attributes)
    @recently_added = true
  end

  def akismet_attributes
    {
      :key => 'b348d02f57ad',
      :blog => 'http://mexicoonrails.com.mx',
      :user_ip => user_ip,
      :user_agent => user_agent,
      :comment_author => name,
      :comment_author_email => email,
      :comment_author_url => site_url,
      :comment_content => content_html
    }
  end

  def textilize_content_and_add_protocol_to_url
    self.content_html = RedCloth.new(ActionController::Base.helpers.sanitize(content, :tags => %w(pre code a strong em blockquote br p)),
      [:filter_styles, :filter_ids, :no_span_caps]).to_html
    self.site_url = "http://#{site_url}" unless site_url.blank? || site_url =~ /\Ahttps?:\/\/.*/i
  end
end
