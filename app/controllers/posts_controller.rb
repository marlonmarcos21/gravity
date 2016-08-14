class PostsController < ApplicationController
  load_and_authorize_resource

  before_action :post, only: [:show, :edit, :update, :destroy, :publish, :unpublish, :editable]

  before_action :prepare_images, only: [:new, :edit]
  before_action :image_token,    only: [:new, :index]

  def index
    pp_scope = Post.includes(:user).published.descending
    @post  = Post.new
    @posts = pp_scope.page(1)
    @has_more_results = !pp_scope.page(2).empty?
  end

  def more_published_posts
    pp_scope = Post.includes(:user).published.descending
    page = params[:page].blank? ? 2 : params[:page].to_i
    @next_page = page + 1
    @posts = pp_scope.page(page)
    @has_more_results = !pp_scope.page(@next_page).empty?

    respond_to do |format|
      format.html { render :index }
      format.js
    end
  end

  def show
    @new_comment = Comment.build_from(@post, current_user.id, nil) if current_user
  end

  def new
    @post = Post.new
    @post.images.build
  end

  def edit
    @image_token = @post.images.first.try(:token) || image_token
  end

  def create
    @new_post = Post.new(post_params)
    @new_post.user = current_user
    img_token  = params.delete :image_token
    respond_to do |format|
      if @new_post.save
        flash[:notice] = 'Post created!'
        attach_images img_token, @new_post.id
        attach_videos img_token, @new_post.id
        image_token
        @post = Post.new
        @post.images.build

        format.html { redirect_to @new_post }
        format.js { render :new_post }
      else
        render :new
      end
    end
  end

  def update
    img_token = params.delete :image_token

    if @post.update(post_params)
      attach_images img_token, @post.id
      attach_videos img_token, @new_post.id
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def editable
    attrs = {}
    attrs[params[:name]] = params[:value]

    respond_to do |format|
      if @post.update_attributes(attrs)
        flash[:notice] = 'Post updated!'
        format.html { redirect_to @post }
        format.json { render json: { message: 'success', post_id: post.id, content: @post.embed_youtube }, status: 200 }
      else
        flash[:alert] = 'Post update failed!'
        format.html { redirect_to @post }
        format.json { render json: { message: 'failed' }, status: 422 }
      end
    end
  end

  def upload_image
    image_token = params[:image_token]
    return if image_token.blank?
    image_params = params[:post][:images_attributes]
    return unless image_params
    image_params.each_value do |img|
      if img['source'].content_type == 'video/mp4'
        Video.create(
          token: image_token,
          source: img['source']
        )
      else
        Image.create(
          token: image_token,
          source: img['source']
        )
      end
    end
    render json: {}, status: 200
  end

  def remove_image
    attrs = {
      source_file_name: params[:source_file_name],
      token: params[:image_token]
    }
    img = Image.where(attrs).first
    video = Video.where(attrs).first
    img.try(:destroy)
    video.try(:destroy)
    render json: {}, status: 200
  end

  def destroy
    @post.destroy
    respond_to do |format|
      flash[:alert] = 'Post deleted!'
      format.html { redirect_to posts_url }
      format.json { render json: { message: 'Post deleted!' } }
    end
  end

  def publish
    if @post.publish!
      redirect_to @post, notice: 'Post published!'
    else
      render :edit, alert: 'Error publishing post!'
    end
  end

  def unpublish
    @post.unpublish!
    redirect_to @post, alert: 'Post unpublished!'
  end

  private

  def post
    @post = Post.includes(:images).find(params[:id])
  end

  def post_params
    permitted_params = %i(body published private)
    params.require(:post).permit(*permitted_params)
  end

  def attach_images(img_token, post_id)
    return if img_token.blank?
    images = Image.where(token: img_token)
    images.update_all(attachable_id: post_id, attachable_type: 'Post') if images.any?
  end

  def attach_videos(img_token, post_id)
    return if img_token.blank?
    videos = Video.where(token: img_token)
    videos.update_all(attachable_id: post_id, attachable_type: 'Post') if videos.any?
  end

  def prepare_images
    return unless @post.try(:images).try(:any?)
    hash = {}
    @post.images.each do |img|
      hash[img.id.to_s] = { img_url: img.source.url,
                            img_url_thumb: img.source.url(:thumb),
                            size: img.source_file_size,
                            file_name: img.source_file_name,
                            width: img.width,
                            height: img.height }
    end
    @images = hash.to_json
  end

  def image_token
    @image_token = SecureRandom.urlsafe_base64(30)
  end
end
