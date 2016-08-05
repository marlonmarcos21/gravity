class HomeController < ApplicationController
  before_action :recent_posts

  def index
  end

  private

  def recent_posts
    @posts = Post.recent(3)
  end
end
