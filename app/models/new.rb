class New < ActiveRecord::Base
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  validates_presence_of :title, :content

  before_save :sanitize_content

  named_scope :recent, lambda { |*args| {:limit => (args.first || 3), :order => 'created_at DESC'} }

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
