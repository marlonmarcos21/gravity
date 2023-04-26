class ChatsController < ApplicationController
  # load_and_authorize_resource

  def index
    @users = User.where.not(id: current_user.id)
  end
end
