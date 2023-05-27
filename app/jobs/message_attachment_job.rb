class MessageAttachmentJob < ApplicationJob
  queue_as :default

  def perform(id, source, file_name)
    attachment = Chat::MessageAttachment.find(id)
    attachment.source = source
    attachment.source_file_name = file_name
    attachment.save
  end
end
