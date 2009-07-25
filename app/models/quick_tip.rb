class QuickTip < ActiveRecord::Base
  validates_presence_of :content

  before_save :sanitize_content

  def self.random
    (tips = all)[rand(tips.size)]
  end

  protected

  def sanitize_content
    self.content = ActionController::Base.helpers.sanitize(content)
  end
end
