# frozen_string_literal: true

class GravityChannel < ApplicationCable::Channel
  def subscribed
    reject if chat_group.nil? || chat_group.participants.exclude?(current_user)

    stream_for chat_group
  end

  def receive(data)
    create_message(data) unless data.key?('is_typing')
    broadcast_to(chat_group, data)
  end

  def unsubscribed
    stop_all_streams
  end

  private

  def chat_group
    @chat_group ||= Chat::Group.find_by(id: params[:room_id])
  end

  def create_message(data)
    msg = chat_group.messages.build(
      sender: current_user,
      body: data['body']
    )

    msg.receipts.build(
      chat_group_id: chat_group.id,
      receipt_type: 'outbox',
      user: current_user,
      message: msg
    )

    chat_group.participants.where.not(id: current_user.id).each do |p|
      msg.receipts.build(
        chat_group_id: chat_group.id,
        receipt_type: 'inbox',
        user: p,
        message: msg
      )
    end

    msg.save!
  end
end
