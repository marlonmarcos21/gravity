# frozen_string_literal: true

class GravityChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def receive(data)
    broadcast_to(current_user, data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
