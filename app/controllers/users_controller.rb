class UsersController < ApplicationController
  load_and_authorize_resource

  before_action :user, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @user = User.new
    @user.user_profile = UserProfile.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: 'User was successfully created!'
    else
      render :new
    end
  end

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete('password')
      params[:user].delete('password_confirmation')
    end

    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  private

  def user
    @user = User.includes(:user_profile, :posts, :blogs).find(params[:id])
  end

  def user_params
    dob = params[:user][:user_profile_attributes][:date_of_birth]
    params[:user][:user_profile_attributes][:date_of_birth] = Date.strptime(dob, '%m/%d/%Y').to_s unless dob.blank?
    permitted_params = [
      :email, :password, :password_confirmation, :profile_photo,
      user_profile_attributes: [
        :id, :first_name, :last_name, :date_of_birth, :street_address1,
        :street_address2, :city, :state, :country, :postal_code,
        :phone_number, :mobile_number, :_destroy
      ]
    ]
    params.require(:user).permit(*permitted_params)
  end
end
