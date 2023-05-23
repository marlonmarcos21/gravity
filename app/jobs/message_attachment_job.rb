class MessageAttachmentJob < ApplicationJob
  queue_as :default

  def perform(id, source)
    attachment = Chat::MessageAttachment.find(id)
    attachment.source = source
    attachment.save
  end
end
