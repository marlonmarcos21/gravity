# frozen_string_literal: true

# Customisations to Action Text:
#
#   1. A RemoteVideo attachable, so Trix attachments whose content-type is a
#      video render through app/views/action_text/attachables/_remote_video.
#      Upstream only recognises remote *images* (ActionText::Attachables::RemoteImage),
#      so without this a video attachment falls back to MissingAttachable.
#   2. Sanitizer allow-lists extended with the tags/attributes those videos need.
#
# Everything else is left to Action Text's own implementation. This file used to
# carry a copy of Rails 6's ActionText::ContentHelper; that copy has been dropped
# because it overrode rendering/sanitizing methods that have since changed.

module ActionText
  module Attachables
    class RemoteVideo
      extend ActiveModel::Naming

      class << self
        def from_node(node)
          return unless node['url'] && content_type_is_video?(node['content-type'])

          new(attributes_from_node(node))
        end

        private

        def content_type_is_video?(content_type)
          content_type.to_s.match?(%r{^video(/.+|$)})
        end

        def attributes_from_node(node)
          { url: node['url'], content_type: node['content-type'] }
        end
      end

      attr_reader :url, :content_type

      def initialize(attributes = {})
        @url = attributes[:url]
        @content_type = attributes[:content_type]
      end

      def attachable_plain_text_representation(caption)
        "[#{caption || 'Video'}]"
      end

      def to_partial_path
        'action_text/attachables/remote_video'
      end
    end
  end
end

module ActionText
  module Attachable
    extend ActiveSupport::Concern

    class << self
      def from_node(node)
        attachable = attachable_from_sgid(node['sgid'])
        return attachable if attachable

        attachable = ActionText::Attachables::ContentAttachment.from_node(node)
        return attachable if attachable

        attachable = ActionText::Attachables::RemoteImage.from_node(node)
        return attachable if attachable

        attachable = ActionText::Attachables::RemoteVideo.from_node(node)
        return attachable if attachable

        ActionText::Attachables::MissingAttachable
      end
    end
  end
end

# Mirrors ActionText::ContentHelper#sanitizer_allowed_tags / #sanitizer_allowed_attributes
# (actiontext/app/helpers/action_text/content_helper.rb) and appends what
# _remote_video.html.haml emits. Setting these accessors replaces the lazy
# defaults, so the upstream entries have to be repeated here -- in particular
# ActionText::Attachment.tag_name, without which every attachment is stripped.
Rails.application.config.after_initialize do
  helper = ActionText::ContentHelper

  helper.allowed_tags =
    helper.sanitizer.class.allowed_tags +
    [ActionText::Attachment.tag_name, 'figure', 'figcaption', 'video']

  helper.allowed_attributes =
    helper.sanitizer.class.allowed_attributes +
    ActionText::Attachment::ATTRIBUTES +
    %w(controls preload size poster)
end
