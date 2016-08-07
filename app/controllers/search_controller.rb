class SearchController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  before_action :authenticate_user!

  def search
    @search_term = sanitize params[:search][:search]
    return if @search_term.blank?
    user_search @search_term
    post_search @search_term
    blog_search @search_term
  end

  private

  def user_search(search_term)
    user_ids = UserProfile.search(search_term).pluck(:user_id)
    return if user_ids.empty?
    @users = User.active.where(id: user_ids).order(created_at: :desc)
  end

  def post_search(search_term)
    @posts = Post.includes(user: :user_profile)
               .published.search search_term
  end

  def blog_search(search_term)
    @blogs = Blog.includes(user: :user_profile)
               .published.search search_term
  end
end
