class Page < ActiveRecord::Base
  has_permalink :title
  acts_as_list :column => :position

  validates_presence_of :title, :content

  before_save :sanitize_content

  named_scope :all_published, :conditions => {:published => true}, :order => :position
  
  attr_accessible :title, :content, :published

  protected

  def sanitize_content
    content.gsub!(/<img.*src="(.*?)".*?\/>/i) do
      src = $1
      alt = src.gsub!(/\A.*?assets/, '/assets')
      alt = alt.scan(/\/(\w+)\.\w+$/i).to_s unless alt.nil?
      %Q(<img src="#{src}" alt="#{alt}" />)
    end
    self.content = ActionController::Base.helpers.sanitize(content)
  end
end
