class BlogsController < ApplicationController
  load_and_authorize_resource

  before_action :image_token, only: :new

  def index
    pb_scope          = Blog.includes(:user).published.descending
    @blogs            = pb_scope.page(1)
    @has_more_results = pb_scope.page(2).exists?
    @through_category = false
  end

  def more_published_blogs
    pb_scope          = Blog.includes(:user).published.descending
    page              = params[:page].blank? ? 2 : params[:page].to_i
    @next_page        = page + 1
    @blogs            = pb_scope.page(page)
    @has_more_results = pb_scope.page(@next_page).exists?
    @through_category = false

    respond_to do |format|
      format.html { render :index }
      format.js
    end
  end

  def show
    @new_comment = Comment.build_from(@blog, current_user.id) if current_user
  end

  def new
    @blog = Blog.new
    @blog.blog_media.build
  end

  def edit
    @image_token = @blog.blog_media.first.try(:token) || image_token
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
      CleanUpBlogImagesJob.perform_later @blog.id
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
      format.json { render json: { message: 'Blog deleted!' } }
    end
  end

  def publish
    if @blog.publish!
      redirect_to @blog, notice: 'Blog published!'
    else
      render :edit, alert: 'Error publishing blog!'
    end
  end

  def unpublish
    @blog.unpublish!
    redirect_to @blog, alert: 'Blog unpublished!'
  end

  def tinymce_assets
    img = BlogMedium.create(
      source: params[:file],
      token: params[:hint]
    )
    if img.persisted?
      render json: {
        image: {
          url: img.source_url
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

  def like
    @blog.likes.create(user: current_user)
    @blog.create_activity :like, recipient: @blog.user
    total_likes = @blog.likes.count

    respond_to do |format|
      flash[:notice] = 'Blog liked!'
      format.html { redirect_to @blog }
      format.json do
        render json: {
          key: 'blog_like_unlike',
          blog_id: @blog.id,
          action: 'like',
          total_likes: total_likes,
          message: 'Blog liked!'
        }
      end
    end
  end

  def unlike
    @blog.likes.find_by(user: current_user).destroy
    @blog.create_activity :unlike, recipient: @blog.user
    total_likes = @blog.likes.count

    respond_to do |format|
      flash[:alert] = 'Blog unliked!'
      format.html { redirect_to @blog }
      format.json do
        render json: {
          key: 'blog_like_unlike',
          blog_id: @blog.id,
          action: 'unlike',
          total_likes: total_likes,
          message: 'Blog unliked!'
        }
      end
    end
  end

  private

  def blog_params
    params[:blog][:body] = params['tinymce-container']
    permitted_params = %i(category_id title body)
    params.require(:blog).permit(*permitted_params)
  end

  def image_token
    @image_token ||= SecureRandom.urlsafe_base64(30)
  end

  def attach_images(img_token)
    return if img_token.blank?

    images = BlogMedium.where(token: img_token)
    images.update_all(attachable_id: @blog.id, attachable_type: 'Blog') if images.any?
  end
end
