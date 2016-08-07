class Ability
  include CanCan::Ability

  attr_reader :current_user

  def initialize(user)
    @current_user = user || User.new

    if current_user.persisted? && current_user.id == 1
      can :manage, :all
      return
    end

    post_permissions
    blog_permissions
    user_permissions
  end

  private

  def post_permissions
    can :read, Post do |post|
      post.published? || post.user == current_user
    end
    can [:update, :destroy, :publish, :unpublish], Post do |post|
      post.user == current_user
    end
    can [:create, :upload_image, :remove_image], Post do
      current_user.persisted?
    end
  end

  def blog_permissions
    can :read, Blog do |blog|
      blog.published? || blog.user == current_user
    end
    can [:update, :destroy, :publish, :unpublish], Blog do |blog|
      blog.user == current_user
    end
    can :create, Blog do
      current_user.persisted?
    end
  end

  def user_permissions
    can :read, User do |user|
      current_user.persisted?
    end
    can :update, User do |user|
      user == current_user
    end
  end
end
