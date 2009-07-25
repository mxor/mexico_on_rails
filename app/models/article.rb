class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  validates_presence_of :title, :excerpt, :body

  attr_accessible :title, :excerpt, :body, :level, :tag_list

  has_permalink :title
  acts_as_taggable
  ajaxful_rateable :allow_update => false

  named_scope :recent, lambda { |*args| {:limit => (args.first || 3), :order => 'created_at DESC'} }

  before_save :sanitize_attributes

  def self.levels
    %w(Principiante Intermedio Avanzado Experto).freeze
  end

  protected

  def sanitize_attributes
    [excerpt, body].each do |attr|
      attr.gsub!(/<img.*src="(.*?)".*?\/>/i) do
        src = $1
        alt = src.gsub!(/\A.*?assets/, '/assets')
        alt = alt.scan(/\/(\w+)\.\w+$/i).to_s unless alt.nil?
        %Q(<img src="#{src}" alt="#{alt}" />)
      end
      attr = ActionController::Base.helpers.sanitize(attr)
    end
  end
end
