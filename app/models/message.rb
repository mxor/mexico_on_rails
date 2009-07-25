class Message < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  has_many :message_copies
  has_many :recipients, :through => :message_copies

  validates_presence_of :subject, :body, :to

  attr_writer :to
  attr_accessible :subject, :body, :to

  before_create :prepare_copies

  def to
    @to ||= []
  end

  def prepare_copies
    return if to.blank?

    to.uniq.each do |recipient|
      recipient = User.find(recipient)
      message_copies.build(:recipient_id => recipient.id, :folder_id => recipient.inbox.id)
    end
  end
end
