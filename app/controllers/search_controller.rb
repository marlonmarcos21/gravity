class SearchController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  before_action :authenticate_user!

  def search
    @search_term = sanitize params[:search][:search]

    return if @search_term.blank?

    user_search
    post_search
    blog_search
  end

  private

  def user_search
    @users = User.active.search(@search_term)
  end

  def post_search
    @posts = Post
               .includes(user: :user_profile)
               .published
               .search(@search_term)
  end

  def blog_search
    @blogs = Blog
               .includes(user: :user_profile)
               .published
               .search(@search_term)
  end
end
