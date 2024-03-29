# frozen_string_literal: true

class GravityChannel < ApplicationCable::Channel
  include AfterCommitEverywhere

  def subscribed
    reject if chat_group.nil?
    stream_for chat_group
    stream_from "chat_group_#{chat_group.id}" if params[:chat_list]
  end

  def receive(data)
    if data['sender_id'].present?
      data['avatar_source'] =
        if data['sender_id'] == current_user.id
          current_user.profile_photo_url(:thumb)
        else
          User.find(data['sender_id']).profile_photo_url(:thumb)
        end
    end

    broadcast_to(chat_group, data)

    if data.key?('body')
      broadcast_to("chat_group_#{chat_group.id}", data)
      create_message(data)
    elsif data.key?('is_read')
      update_receipts
    end
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

    if data['attachment'].present?
      msg.attachments.build(
        source_file_name: data['file_name']
      )
    end

    msg.save!

    after_commit do
      attachment_id = msg.attachments.first&.id
      MessageAttachmentJob.perform_later(attachment_id, data['attachment'], data['file_name']) if attachment_id
    end
  end

  def update_receipts
    chat_group
      .message_receipts
      .inbox
      .unread
      .where(user: current_user)
      .update_all(is_read: true)

    Rails.cache.delete "user/#{current_user.id}/message-count"
  end
end
