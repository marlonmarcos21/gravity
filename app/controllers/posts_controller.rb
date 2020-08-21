class PostsController < ApplicationController
  authorize_resource

  before_action :post, only: %i(show edit update destroy editable like unlike)
  before_action :prepare_images, only: :edit
  before_action :media_token, only: %i(new index create)

  def index
    posts_scope       = posts_collection
    @has_more_results = posts_scope.page(2).exists?
    @post             = Post.new
    @posts            = posts_scope.page(1)
  end

  def more_published_posts
    posts_scope       = posts_collection
    page              = params[:page].blank? ? 2 : params[:page].to_i
    @next_page        = page + 1
    @has_more_results = posts_scope.page(@next_page).exists?
    @posts            = posts_scope.page(page)
    respond_to :js
  end

  def show
    @new_comment = Comment.build_from(@post, current_user.id) if current_user
  end

  def new
    @post = Post.new
  end

  def edit
    @media_token = @post.images.first.try(:token) || media_token
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    medium_token = params.delete :media_token
    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post created'
        attach_images medium_token, @post.id
        attach_videos medium_token, @post.id
        @new_post = @post
        @post = Post.new
        format.html { redirect_to @new_post }
        format.js   { render :new_post }
      else
        flash[:alert] = 'Error creating post'
        format.html { render :new }
        format.js   { render body: nil, content_type: 'text/html' }
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
      if @post.update(attrs)
        flash[:notice] = 'Post updated!'
        format.json do
          render json: {
            message: 'success',
            post_id: @post.id,
            content: @post.embed_youtube,
            private: @post.private?
          }, status: :ok
        end
      else
        flash[:alert] = 'Post update failed!'
        format.json do
          render json: { message: 'failed' },
                 status: :unprocessable_entity
        end
      end
    end
  end

  def remove_media
    destroy_media
    render json: { message: 'success' }, status: :ok
  end

  def destroy
    image_ids = @post.images.pluck(:id)
    video_ids = @post.videos.pluck(:id)
    if image_ids.any? || video_ids.any?
      @post.images.update_all(attachable_id: nil)
      @post.videos.update_all(attachable_id: nil)
      ImageJob.perform_later(image_ids, 'delete') if image_ids.any?
      VideoJob.perform_later(video_ids, 'delete') if video_ids.any?
    end

    @post.destroy
    respond_to do |format|
      flash[:alert] = 'Post deleted!'
      format.html { redirect_to posts_url }
      format.json { render json: { message: 'Post deleted!' } }
    end
  end

  def like
    @post.likes.create(user: current_user)
    @post.create_activity :like, recipient: @post.user
    total_likes = @post.likes.count

    respond_to do |format|
      flash[:notice] = 'Post liked!'
      format.html { redirect_to posts_url }
      format.json do
        render json: {
          key: 'post_like_unlike',
          post_id: @post.id,
          action: 'like',
          total_likes: total_likes,
          message: 'Post liked!'
        }
      end
    end
  end

  def unlike
    @post.likes.find_by(user: current_user).destroy
    @post.create_activity :unlike, recipient: @post.user
    total_likes = @post.likes.count

    respond_to do |format|
      flash[:alert] = 'Post unliked!'
      format.html { redirect_to posts_url }
      format.json do
        render json: {
          key: 'post_like_unlike',
          post_id: @post.id,
          action: 'unlike',
          total_likes: total_likes,
          message: 'Post unliked!'
        }
      end
    end
  end

  def presigned_url
    uuid = SecureRandom.uuid
    presigned_post = BUCKET.presigned_post(
      key: "uploads/#{uuid}/${filename}",
      success_action_status: '201',
      allow_any: ['Content-Type'],
      acl: 'public-read'
    )
    render json: {
      url: presigned_post.url,
      fields: presigned_post.fields,
      uuid: uuid
    }, status: :ok
  end

  def media_upload_callback
    opts = {
      token: params[:media_token],
      key: params[:s3_key],
      attachable_type: 'Post'
    }
    if params[:content_type].starts_with?('video')
      Video.create(**opts)
    else
      Image.create(**opts)
    end
    render json: { message: 'success' }, status: :ok
  end

  def pre_post_check
    ready = REDIS.smembers(params[:media_token]).empty?
    render json: { ready: ready }, status: :ok
  end

  private

  def posts_collection
    current_user ? Post.all_viewable : Post.for_public_view
  end

  def post
    @post = Post.includes(:images).find(params[:id])
  end

  def post_params
    permitted_params = %i(body published public)
    params.require(:post).permit(*permitted_params)
  end

  def destroy_media
    attrs = {
      key: params[:s3_key],
      token: params[:media_token],
      attachable_type: 'Post'
    }
    imgs = Image.where(attrs)
    videos = Video.where(attrs.except(:key))
    return unless imgs.any? || videos.any?

    if imgs.any?
      imgs.update_all(attachable_id: nil)
      ImageJob.perform_later(imgs.pluck(:id), 'delete')
    end
    if videos.any?
      videos.update_all(attachable_id: nil)
      VideoJob.perform_later(videos.pluck(:id), 'delete')
    end
    post.reload if params[:id]
  end

  def attach_images(token, post_id)
    return if token.blank?

    images = Image.where(token: token, attachable_type: 'Post')
    images.update_all(attachable_id: post_id) if images.exists?
  end

  def attach_videos(token, post_id)
    return if token.blank?

    videos = Video.where(token: token, attachable_type: 'Post')
    videos.update_all(attachable_id: post_id) if videos.exists?
  end

  def prepare_images
    return unless @post.try(:images).try(:any?)

    @images = @post.images.each_with_object({}) do |img, hash|
      style = img.gif? ? :original : :thumb
      hash[img.id.to_s] = {
        img_url: img.source_url(style: :original),
        img_url_thumb: img.source_url(style: style),
        size: img.source_file_size,
        file_name: img.source_file_name,
        width: img.width,
        height: img.height
      }
    end.to_json
  end

  def media_token
    @media_token = SecureRandom.urlsafe_base64(30)
  end
end
