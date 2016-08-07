class HomeController < ApplicationController
  before_action :recent_posts
  before_action :recent_blogs

  def index
  end

  private

  def recent_posts
    @posts = Post.recent(3)
  end

  def recent_blogs
    @blogs = Blog.recent(3)
  end
end
