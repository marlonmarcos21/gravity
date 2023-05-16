class ChatsController < ApplicationController
  authorize_resource

  def index
    @users = User.where.not(id: current_user.id)
  end

  def conversations
    page = (params[:page].presence || 1).to_i
    chat_groups =
      current_user
        .chat_groups
        .merge(Chat::GroupsUser.joined)
        .order(updated_at: :desc)
        .page(page)

    data = chat_groups.map do |cg|
      other_user = cg.users.where.not(id: current_user.id).first  # TODO: optimize
      {
        id: cg.id,
        firstName: cg.chat_room_name.presence || "#{other_user.first_name} #{other_user.last_name}",
        message: "Test message",
        avatarSrc: other_user.profile_photo_url(:thumb)
      }
    end

    render json: data
  end
end
