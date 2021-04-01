class RecipesController < ApplicationController
  # authorize_resource

  def index
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
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
end
