class ChatsController < ApplicationController
  def index
    authorize! :index, :chat
  end

  def conversations
    authorize! :index, :chat
    chat_groups =
      current_user
        .chat_groups
        .includes(:users, last_message: :attachments)
        .merge(Chat::GroupsUser.joined)
        .order(updated_at: :desc)
        .page(page)

    data = chat_groups.map do |cg|
      other_users = cg.users.to_a.reject { |u| u.id == current_user.id }
      {
        id: cg.id,
        roomName: cg.chat_room_name.presence || "#{other_users.first.first_name} #{other_users.first.last_name}",
        message: cg.last_message&.body.presence || cg.last_message&.attachments&.first&.source_file_name,
        avatarSources: other_users.map { |u| u.profile_photo_url(:thumb) }
      }
    end

    render json: data
  end

  def conversation
    authorize! :show, chat_group
    other_users = chat_group.users.where.not(id: current_user.id).to_a
    data = {
      id: chat_group.id,
      roomName: chat_group.chat_room_name.presence || "#{other_users.first.first_name} #{other_users.first.last_name}",
      message: chat_group.last_message&.body,
      avatarSources: other_users.map { |u| u.profile_photo_url(:thumb) }
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
