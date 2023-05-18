class ChatsController < ApplicationController
  authorize_resource class: false

  before_action :authorize_chat_group_access, only: :show

  def index
    @users = User.where.not(id: current_user.id)
  end

  def conversations
    chat_groups =
      current_user
        .chat_groups
        .includes(:last_message)
        .merge(Chat::GroupsUser.joined)
        .order(updated_at: :desc)
        .page(page)

    data = chat_groups.map do |cg|
      other_user = cg.users.where.not(id: current_user.id).first  # TODO: optimize
      {
        id: cg.id,
        firstName: cg.chat_room_name.presence || "#{other_user.first_name} #{other_user.last_name}",
        message: cg.last_message&.body,
        avatarSrc: other_user.profile_photo_url(:thumb)
      }
    end

    render json: data
  end

  def show
    messages =
      chat_group
        .messages
        .order(created_at: :desc)
        .page(page)

    render json: messages
  end

  private

  def authorize_chat_group_access
    return if chat_group&.participants&.exists?(id: current_user.id)

    render(
      json: { error: 'Invalid or unauthorized to access chat group' },
      status: :unprocessable_entity
    )
  end

  def chat_group
    @chat_group ||= Chat::Group.find_by(id: params[:id])
  end

  def page
    @page ||= (params[:page].presence || 1).to_i
  end
end
