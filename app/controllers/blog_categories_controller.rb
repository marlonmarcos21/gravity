class BlogCategoriesController < ApplicationController
  load_resource class: Category::Blog

  def blogs
    blog_scope        = @blog_category.blogs.includes(:user).published.descending
    @blogs            = blog_scope.page(1)
    @has_more_results = blog_scope.page(2).exists?
    @through_category = true

    render 'blogs/index'
  end

  def more_published_blogs
    blog_scope        = @blog_category.blogs.includes(:user).published.descending
    page              = params[:page].blank? ? 2 : params[:page].to_i
    @next_page        = page + 1
    @blogs            = blog_scope.page(page)
    @has_more_results = blog_scope.page(@next_page).exists?
    @through_category = true

    respond_to do |format|
      format.html { render 'blogs/index' }
      format.js   { render 'blogs/more_published_blogs' }
    end
  end
end
