class CommentObserver < ActiveRecord::Observer
  # def after_create(comment)
  #   unless comment.approved?
  #     User.find_all_by_admin(true).each do |admin|
  #       UserMailer.deliver_spam_notification(admin, comment)
  #     end
  #   else
  #     UserMailer.deliver_comment_notification(comment.commentable.user, comment) if comment.commentable_type == 'Article'
  #   end
  # end
end
