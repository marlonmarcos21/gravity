class ChatsController < ApplicationController
  def index
    authorize! :index, :chat
  end

  def conversations
    authorize! :index, :chat
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

  def conversation
    authorize! :show, chat_group
    other_user = chat_group.users.where.not(id: current_user.id).first  # TODO: optimize
    data = {
      id: chat_group.id,
      firstName: chat_group.chat_room_name.presence || "#{other_user.first_name} #{other_user.last_name}",
      message: chat_group.last_message&.body,
      avatarSrc: other_user.profile_photo_url(:thumb)
    }

    render json: data
  end

  def show
    authorize! :show, chat_group
    messages =
      chat_group
        .messages
        .includes(:attachments)
        .order(created_at: :desc)
        .page(page)

    render json: messages
  end

  private

  def chat_group
    @chat_group ||= Chat::Group.find_by(id: params[:id])
  end

  def page
    @page ||= (params[:page].presence || 1).to_i
  end
end
