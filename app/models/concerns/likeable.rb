module Likeable
  extend ActiveSupport::Concern

  def liked_by?(current_user)
    likes.where(user: current_user).exists?
  end
end
