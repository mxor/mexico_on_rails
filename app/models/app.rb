class App < ActiveRecord::Base
  belongs_to :user
  has_one :screenshot, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy

  validates_presence_of :name, :description, :site_url
  validates_format_of :site_url, :with => /\A.*?(?:[A-Z0-9\-]+\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)(.*?)\z/i

  attr_protected :user_id
  attr_reader :new_uploaded_screenshot

  named_scope :recent, lambda { |*args| {:limit => (args.first || 3), :order => 'created_at DESC'} }

  before_save :sanitize_description_and_url

  def validate
    if screenshot.blank?
      errors.add(:uploaded_screenshot, :blank)
    else
      errors.add(:uploaded_screenshot, :invalid_image) unless screenshot.valid?
    end

    if !new_record? && !new_uploaded_screenshot.blank?
      unless new_uploaded_screenshot.valid?
        errors.add(:new_uploaded_screenshot, :invalid_image)
      else
        self.screenshot = new_uploaded_screenshot
      end
    end
  end

  def uploaded_screenshot=(screenie)
    build_screenshot(:uploaded_data => screenie) unless screenie.blank?
  end

  def new_uploaded_screenshot=(screenie)
    @new_uploaded_screenshot ||= Screenshot.new(:uploaded_data => screenie) unless screenie.blank?
  end

  def site_url_without_protocol
    site_url.scan(/\Ahttps?:\/\/(.*)/i).to_s
  end

  protected

  def sanitize_description_and_url
    self.description =  ActionController::Base.helpers.sanitize(description)
    self.site_url = "http://#{site_url}" unless site_url =~ /\Ahttps?:\/\/.*/i
  end
end
