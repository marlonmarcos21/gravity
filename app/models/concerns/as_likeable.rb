module AsLikeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :trackable, dependent: :destroy
  end

  def liked_by?(current_user)
    likes.where(user: current_user).exists?
  end
end
