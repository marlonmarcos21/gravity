class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, Post
    can [:update, :destroy], Post do |post|
      post.user == user
    end
    can [:create, :upload_image, :remove_image], Post do
      user.persisted?
    end
  end
end
