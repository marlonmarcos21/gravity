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
    user_permissions
  end

  private

  def post_permissions
    can :read, Post
    can [:update, :destroy, :publish, :unpublish], Post do |post|
      post.user == current_user
    end
    can [:create, :upload_image, :remove_image], Post do
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
