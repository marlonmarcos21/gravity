class PostsController < ApplicationController
  load_and_authorize_resource

  before_action :post, only: %i(show edit update destroy editable)

  before_action :prepare_images, only: :edit
  before_action :media_token,    only: %i(new index)

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
    respond_to :js
  end

  def show
    @new_comment = Comment.build_from(@post, current_user.id, nil) if current_user
  end

  def new
    @post = Post.new
  end

  def edit
    @media_token = @post.images.first.try(:token) || media_token
  end

  def create
    @post.user = current_user
    medium_token = params.delete :media_token
    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post created'
        attach_images medium_token, @post.id
        attach_videos medium_token, @post.id
        media_token
        @new_post = @post
        @post = Post.new

        format.html { redirect_to @new_post }
        format.js   { render :new_post }
      else
        flash[:alert] = 'Error creating post'
        format.html { render :new }
        format.js   { render nothing: true, content_type: 'text/html' }
      end
    end
  end

  def update
    medium_token = params.delete :media_token

    if @post.update(post_params)
      attach_images medium_token, @post.id
      attach_videos medium_token, @post.id
      redirect_to @post, notice: 'Post updated'
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
        format.json { render json: { message: 'success', post_id: post.id, content: @post.embed_youtube },
                             status: 200 }
      else
        flash[:alert] = 'Post update failed!'
        format.json { render json: { message: 'failed' }, status: 422 }
      end
    end
  end

  def upload_media
    if create_media
      render json: { message: 'success' }, status: 200
    else
      render json: { message: 'failed' }, status: 422
    end
  end

  def remove_media
    if destroy_media == false
      render json: { message: 'failed' }, status: 422
    else
      render json: { message: 'success' }, status: 200
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      flash[:alert] = 'Post deleted!'
      format.html { redirect_to posts_url }
      format.json { render json: { message: 'Post deleted!' } }
    end
  end

  private

  def post
    @post = Post.includes(:images).find(params[:id])
  end

  def post_params
    permitted_params = %i(body published private)
    params.require(:post).permit(*permitted_params)
  end

  def create_media
    media_token = params[:media_token]
    return if media_token.blank?
    media_params = params[:post][:media_attributes]
    return if media_params.blank?
    media_params.each_value do |medium|
      if medium['source'].content_type == 'video/mp4'
        Video.create(
          token: media_token,
          source: medium['source']
        )
      else
        Image.create(
          token: media_token,
          source: medium['source']
        )
      end
    end
  end

  def destroy_media
    attrs = {
      source_file_name: params[:source_file_name],
      token: params[:media_token]
    }
    img = Image.where(attrs).first
    video = Video.where(attrs).first
    return false unless img || video
    img.try(:destroy)
    video.try(:destroy)
  end

  def attach_images(token, post_id)
    return if token.blank?
    images = Image.where(token: token)
    images.update_all(attachable_id: post_id, attachable_type: 'Post') if images.any?
  end

  def attach_videos(token, post_id)
    return if token.blank?
    videos = Video.where(token: token)
    videos.update_all(attachable_id: post_id, attachable_type: 'Post') if videos.any?
  end

  def prepare_images
    return unless @post.try(:images).try(:any?)
    hash = {}
    @post.images.each do |img|
      hash[img.id.to_s] = { img_url: img.source_url(:main),
                            img_url_thumb: img.source_url(:thumb),
                            size: img.source_file_size,
                            file_name: img.source_file_name,
                            width: img.width,
                            height: img.height }
    end
    @images = hash.to_json
  end

  def media_token
    @media_token = SecureRandom.urlsafe_base64(30)
  end
end
