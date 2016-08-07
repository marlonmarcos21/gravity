class BlogsController < ApplicationController
  load_and_authorize_resource

  before_action :blog, only: [:show, :edit, :update, :destroy, :publish, :unpublish]

def index
    page   = params[:page] || 1
    @blogs = Blog.includes(:user).published.page(page)
  end

  def show
  end

  def new
    @blog = Blog.new
    @blog.images.build
  end

  def edit
  end

  def create
    @blog = Blog.new(blog_params)
    @blog.user = current_user

    if @blog.save
      redirect_to @blog, notice: 'Blog was successfully created!'
    else
      render :new
    end
  end

  def update
    if @blog.update(blog_params)
      redirect_to @blog, notice: 'Blog was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @blog.destroy
    redirect_to blogs_url, notice: 'Blog was successfully deleted!'
  end

  def publish
    if @blog.publish!
      redirect_to @blog, notice: 'Blog successfully published!'
    else
      render :edit, alert: 'Error publishing blog!'
    end
  end

  def unpublish
    @blog.unpublish!
    redirect_to @blog, notice: 'blog successfully unpublished!'
  end

  def tinymce_assets
    img = Image.create(source: params[:file])
    if img.persisted?
      render json: {
        image: {
          url: img.source.url
        }
      }, content_type: 'text/html'
    else
      render json: {
        error: {
          message: 'Error uploading image, please try again'
        }
      }
    end
  end

  private

  def blog
    @blog = Blog.includes(:images).find(params[:id])
  end

  def blog_params
    permitted_params = %i(title body published)
    params.require(:blog).permit(*permitted_params)
  end
end
