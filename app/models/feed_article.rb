class FeedArticle < ActiveRecord::Base
  belongs_to :user
  acts_as_feed
  validates_presence_of :feed_url
  
  attr_accessible :feed_url
  
  after_save :update_feed
  
  def filled?
    !data.blank?
  end

  #SHORTHAND METHODS
  def data
    @data ||= feed_data.blank? ? {} : YAML.load(feed_data)
  end

  def title
    data[:title]
  end

  def description
    data[:description]
  end

  def entries
    @entries ||= (data[:entries]||[]).map {|data|ActsAsFeed::FeedEntry.new(data)}
  end
end
