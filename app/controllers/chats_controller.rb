class ChatsController < ApplicationController
  # load_and_authorize_resource
  authorize_resource

  def index
    @users = User.where.not(id: current_user.id)
  end

  def conversations
    id = (params[:page].presence || 1).to_i
    data = 10.times.map do |i|
      d = {
        id: id,
        firstName: "Marlon #{id}",
        lastName: "Marcos",
        message: "The quick brown fox jumps over the lazy dog.",
        avatarSrc: "https://static-dev.gravity.ph/users/profile_photos/000/000/001/thumb/mm.jpg?1642640892"
      }
      id += 1
      d
    end

    render json: data
  end
end
