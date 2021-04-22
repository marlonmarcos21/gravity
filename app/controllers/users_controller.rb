class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    pp_scope = @user.posts.published.descending
    dp_scope = @user.posts.unpublished.order(updated_at: :desc)
    pb_scope = @user.blogs.published.descending
    db_scope = @user.blogs.unpublished.order(updated_at: :desc)
    dr_scope = @user.recipes.unpublished.order(updated_at: :desc)

    @published_posts = pp_scope.page(1)
    @drafted_posts   = dp_scope.page(1)
    @published_blogs = pb_scope.page(1)
    @drafted_blogs   = db_scope.page(1)
    @drafted_recipes = dr_scope.page(1)

    @more_published_posts_results = !pp_scope.page(2).empty?
    @more_drafted_posts_results   = !dp_scope.page(2).empty?
    @more_published_blogs_results = !pb_scope.page(2).empty?
    @more_drafted_blogs_results   = !db_scope.page(2).empty?
    @more_drafted_recipes_results = !dr_scope.page(2).empty?
  end

  def more_published_posts
    pp_scope = @user.posts.published.descending
    page = params[:page].blank? ? 2 : params[:page].to_i
    @next_page = page + 1

    @published_posts  = pp_scope.page(page)
    @has_more_results = !pp_scope.page(@next_page).empty?

    respond_to do |format|
      format.html { render :show }
      format.js
    end
  end

  def more_published_blogs
    pb_scope = @user.blogs.published.descending
    page = params[:page].blank? ? 2 : params[:page].to_i
    @next_page = page + 1

    @published_blogs  = pb_scope.page(page)
    @has_more_results = !pb_scope.page(@next_page).empty?

    respond_to do |format|
      format.html { render :show }
      format.js
    end
  end

  def more_drafted_blogs
    db_scope       = @user.blogs.unpublished.order(updated_at: :desc)
    @dbpage        = (params[:dbpage] || 2).to_i + 1
    @drafted_blogs = db_scope.page(params[:dbpage] || 2)
    @more_results  = !db_scope.page(@dbpage).empty?

    respond_to do |format|
      format.html { render :show }
      format.js
    end
  end

  def more_drafted_recipes
    recipe_scope     = @user.recipes.unpublished.order(updated_at: :desc)
    @drpage          = (params[:drpage] || 2).to_i + 1
    @drafted_recipes = recipe_scope.page(params[:drpage] || 2)
    @more_results    = !recipe_scope.page(@drpage).empty?

    respond_to do |format|
      format.html { render :show }
      format.js
    end
  end

  def new
    @user = User.new
    @user.user_profile = UserProfile.new
  end

  def edit; end

  def create
    if @user.save
      redirect_to @user, notice: 'User was successfully created!'
    else
      render :new
    end
  end

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      bypass_sign_in(@user) if current_user == @user
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  def send_friend_request
    respond_to do |format|
      if current_user.has_friend_request_from?(@user)
        flash[:notice] = "#{@user.first_name} already sent you a friend request, accept now!"
        format.html { redirect_to :back }
        format.js   { render nothing: true, content_type: 'text/html' }
      elsif current_user.send_friend_request_to(@user)
        UserMailer.delay.send_friend_request(@user, current_user)
        @user.create_activity :send_friend_request
        @post = @user.posts.published.first
        flash[:notice] = 'Request sent!'
        format.html { redirect_to :back }
        format.js
      else
        flash[:alert] = 'Request failed, please try again.'
        format.html { redirect_to :back }
        format.js   { render nothing: true, content_type: 'text/html' }
      end
    end
  end

  def accept_friend_request
    respond_to do |format|
      if current_user.accept_friend_request!(@user)
        UserMailer.delay.accept_friend_request(current_user, @user)
        @user.create_activity :accept_friend_request
        @post = Post.find_by(params[:post_id]) if params[:post_id]
        flash[:notice] = 'Request accepted!'
        format.html { redirect_to :back }
        format.js
      else
        flash[:alert] = 'Accept failed, please try again.'
        format.html { redirect_to :back }
        format.js   { render nothing: true, content_type: 'text/html' }
      end
    end
  end

  def cancel_friend_request
    respond_to do |format|
      if current_user.cancel_friend_request!(@user)
        @user.create_activity :cancel_friend_request
        flash[:notice] = 'Request canceled!'
        format.html { redirect_to :back }
        format.js
      else
        flash[:alert] = 'Cancel failed, please try again.'
        format.html { redirect_to :back }
        format.js   { render nothing: true, content_type: 'text/html' }
      end
    end
  end

  def reject_friend_request
    respond_to do |format|
      if current_user.reject_friend_request!(@user)
        @user.create_activity :reject_friend_request
        flash[:notice] = 'Request rejected!'
        format.html { redirect_to :back }
        format.js
      else
        flash[:alert] = 'Reject failed, please try again.'
        format.html { redirect_to :back }
        format.js   { render nothing: true, content_type: 'text/html' }
      end
    end
  end

  private

  def user_params
    dob = params[:user][:user_profile_attributes][:date_of_birth]
    unless dob.blank?
      dob = Date.strptime(dob, '%m/%d/%Y').to_s
      params[:user][:user_profile_attributes][:date_of_birth] = dob
    end

    permitted_params = [
      :email, :password, :password_confirmation, :profile_photo, :first_name, :last_name,
      {
        user_profile_attributes: [
          :id, :date_of_birth, :street_address1, :street_address2,
          :city, :state, :country, :postal_code, :phone_number,
          :mobile_number, :_destroy
        ]
      }
    ]

    params.require(:user).permit(*permitted_params)
  end
end
