class SearchController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  before_action :authenticate_user!

  def search
    search_term = sanitize params[:search][:search]
    user_search search_term
    post_search search_term
  end

  private

  def user_search(search_term)
    user_ids = UserProfile.search(search_term).pluck(:user_id)
    @users = User.active.where(id: user_ids).order(created_at: :desc)
  end

  def post_search(search_term)
    @posts = Post.published.search search_term
  end
end
