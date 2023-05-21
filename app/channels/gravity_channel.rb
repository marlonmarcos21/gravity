# frozen_string_literal: true

class GravityChannel < ApplicationCable::Channel
  def subscribed
    reject if chat_group.nil?
    stream_for chat_group
    stream_from "chat_group_#{chat_group.id}" if params[:chat_list]
  end

  def receive(data)
    if data.key?('body')
      create_message(data)
      broadcast_to("chat_group_#{chat_group.id}", data)
    elsif data.key?('is_read')
      update_receipts
    end

    broadcast_to(chat_group, data)
  end

  def unsubscribed
    stop_all_streams
  end

  private

  def chat_group
    @chat_group ||=
      Chat::Group
        .joins(:participants)
        .merge(User.where(id: current_user.id))
        .find_by(id: params[:room_id])
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
      message: msg,
      is_read: true
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

  def update_receipts
    chat_group
      .message_receipts
      .inbox
      .unread
      .where(user: current_user)
      .update_all(is_read: true)
  end
end
