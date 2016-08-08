class BlogsController < ApplicationController
  load_and_authorize_resource

  before_action :blog, only:  [:show, :edit, :update, :destroy, :publish, :unpublish]
  before_action :image_token, only: :new

def index
    page   = params[:page] || 1
    @blogs = Blog.includes(user: :user_profile)
               .published.descending.page(page)
  end

  def show
  end

  def new
    @blog = Blog.new
    @blog.images.build
  end

  def edit
    @image_token = @blog.images.first.try(:token) || image_token
  end

  def create
    @blog = Blog.new(blog_params)
    @blog.user = current_user
    img_token  = params.delete :image_token

    if @blog.save
      attach_images img_token
      redirect_to @blog, notice: 'Blog was successfully created!'
    else
      render :new
    end
  end

  def update
    img_token = params.delete :image_token

    if @blog.update(blog_params)
      attach_images img_token
      redirect_to @blog, notice: 'Blog was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @blog.destroy
    respond_to do |format|
      flash[:notice] = 'Blog successfully deleted!'
      format.html { redirect_to blogs_url }
      format.json { render json: { message: 'Post deleted!' } }
    end
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
    img = Image.create(
      source: params[:file],
      token: params[:hint]
    )
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

  def image_token
    @image_token = SecureRandom.urlsafe_base64(30)
  end

  def attach_images(img_token)
    return if img_token.blank?
    images = Image.where(token: img_token)
    images.update_all(attachable_id: @blog.id, attachable_type: 'Blog') if images.any?
  end
end
