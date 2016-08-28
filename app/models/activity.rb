class Activity < PublicActivity::Activity
  include ActionView::Helpers::TagHelper
  include ActionView::Context
  include Rails.application.routes.url_helpers

  scope :descending, -> { order(created_at: :desc) }

  class << self
    def for_notification
      where
        .not(key: ['user.cancel_friend_request', 'user.reject_friend_request'])
        .where(arel_table[:owner_id].not_eq(arel_table[:recipient_id]))
    end
  end

  def human_readable_key
    trackable_url = url_for(trackable)
    case key
    when 'user.send_friend_request'
      'sent you a friend request.'
    when 'user.accept_friend_request'
      'accepted your friend request.'
    when 'post.comment'
      post_url = content_tag(:a, href: trackable_url) do
        'post.'
      end
      "commented on your #{post_url}"
    when 'post.reply_comment', 'blog.reply_comment'
      trackable_url = content_tag(:a, href: trackable_url) do
        'comment.'
      end
      "replied to your #{trackable_url}."
    when 'blog.comment'
      blog_url = content_tag(:a, href: trackable_url) do
        'blog.'
      end
      "commented on your #{blog_url}."
    end
  end
end
