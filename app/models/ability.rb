class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.persisted? && user.id == 1
      can :manage, :all
      return
    end

    can :read, Post
    can [:update, :destroy, :publish, :unpublish], Post do |post|
      post.user == user
    end
    can [:create, :upload_image, :remove_image], Post do
      user.persisted?
    end
  end
end
