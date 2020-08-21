class Activity < PublicActivity::Activity
  EXCLUDED_NOTIFICATION_KEYS = %w(
    user.cancel_friend_request
    user.reject_friend_request
    post.unlike
    blog.unlike
  ).freeze

  include ActionView::Helpers::TagHelper
  include ActionView::Context
  include Rails.application.routes.url_helpers

  scope :descending, -> { order(created_at: :desc) }

  class << self
    def for_notification
      where(arel_table[:owner_id].not_eq(arel_table[:recipient_id]))
        .where.not(key: EXCLUDED_NOTIFICATION_KEYS)
    end
  end

  def human_readable_key
    trackable_url = trackable ? url_for(trackable) : '#'

    html =  case key
            when 'user.send_friend_request'
              'sent you a friend request.'

            when 'user.accept_friend_request'
              'accepted your friend request.'

            when 'post.comment'
              post_url = tag.a(href: trackable_url) { 'post.' }
              "commented on your #{post_url}"

            when 'post.reply_comment', 'blog.reply_comment'
              trackable_url = tag.a(href: trackable_url) { 'comment.' }
              "replied to your #{trackable_url}."

            when 'blog.comment'
              blog_url = tag.a(href: trackable_url) { 'blog.' }
              "commented on your #{blog_url}."

            when 'post.like'
              post_url = tag.a(href: trackable_url) { 'post.' }
              "liked your #{post_url}"

            when 'blog.like'
              blog_url = tag.a(href: trackable_url) { 'blog.' }
              "liked your #{blog_url}"
            end

    html += ' (deleted)' if trackable_url == '#' && key !~ /friend_request/
    html
  end
end
