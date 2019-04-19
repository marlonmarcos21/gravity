class Ability
  include CanCan::Ability

  attr_reader :current_user

  def initialize(user)
    @current_user = user || User.new

    can(:manage, :all) && return if current_user.id == 1

    post_permissions
    blog_permissions
    user_permissions
    comment_permissions
  end

  private

  def post_permissions
    can :more_published_posts, Post

    can :read, Post do |post|
      !post.private? ||
        (post.private? && (post.user == current_user ||
                            current_user.is_friends_with?(post.user)))
    end

    can [:update, :destroy, :editable], Post do |post|
      post.user == current_user
    end

    can [:create, :upload_media, :remove_media], Post do
      current_user.persisted?
    end

    can :like, Post do
      current_user.persisted?
    end

    can :unlike, Post do |post|
      current_user.persisted? && post.liked_by?(current_user)
    end
  end

  def blog_permissions
    can :more_published_blogs, Blog

    can :read, Blog do |blog|
      blog.published? || blog.user == current_user
    end

    can [:update, :destroy, :publish, :unpublish], Blog do |blog|
      blog.user == current_user
    end

    can [:create, :tinymce_assets], Blog do
      current_user.persisted?
    end

    can :like, Blog do
      current_user.persisted?
    end

    can :unlike, Blog do |blog|
      current_user.persisted? && blog.liked_by?(current_user)
    end
  end

  def user_permissions
    can [:read, :more_published_posts, :more_published_blogs], User

    can [:update, :more_drafted_blogs], User do |user|
      current_user == user
    end

    can :send_friend_request, User do |user|
      current_user.persisted? &&
        current_user != user &&
        !current_user.is_friends_with?(user) &&
        !current_user.requested_to_be_friends_with?(user)
    end

    can :accept_friend_request, User do |user|
      current_user.persisted? &&
        current_user != user &&
        !current_user.is_friends_with?(user) &&
        current_user.has_friend_request_from?(user)
    end

    can :cancel_friend_request, User do |user|
      current_user.persisted? &&
        current_user != user &&
        !current_user.is_friends_with?(user) &&
        user.has_friend_request_from?(current_user)
    end

    can :reject_friend_request, User do |user|
      current_user.persisted? &&
        current_user != user &&
        !current_user.is_friends_with?(user) &&
        current_user.has_friend_request_from?(user)
    end
  end

  def comment_permissions
    can :create, Comment do
      current_user.persisted?
    end

    can :destroy, Comment do |comment|
      comment.user == current_user || comment.commentable.user == current_user
    end

    can :editable, Comment do |comment|
      comment.user == current_user
    end
  end
end
