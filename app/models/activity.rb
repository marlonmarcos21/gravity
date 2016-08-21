class Activity < PublicActivity::Activity
  scope :descending, -> { order(created_at: :desc) }

  class << self
    def for_notification
      where.not(key: ['user.cancel_friend_request', 'user.reject_friend_request'])
        .where(arel_table[:owner_id].not_eq(arel_table[:recipient_id]))
    end
  end

  def human_readable_key
    case key
    when 'user.send_friend_request'
      'sent you a friend request.'
    when 'user.accept_friend_request'
      'accepted your friend request.'
    when 'post.comment'
      'commented on your post.'
    when 'post.reply_comment', 'blog.reply_comment'
      'replied to your comment.'
    when 'blog.comment'
      'commented on your blog.'
    end
  end
end
