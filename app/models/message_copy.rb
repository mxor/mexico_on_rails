class MessageCopy < ActiveRecord::Base
  belongs_to :message
  belongs_to :recipient, :class_name => 'User'
  belongs_to :folder
  delegate :author, :created_at, :subject, :body, :recipients, :to => :message
end
