# frozen_string_literal: true

require "rails-html-sanitizer"

module ActionText
  module Attachables
    class RemoteVideo
      extend ActiveModel::Naming

      class << self
        def from_node(node)
          if node["url"] && content_type_is_video?(node["content-type"])
            new(attributes_from_node(node))
          end
        end

        private

        def content_type_is_video?(content_type)
          content_type.to_s.match?(/^video(\/.+|$)/)
        end

        def attributes_from_node(node)
          { url: node["url"],
            content_type: node["content-type"] }
        end
      end

      attr_reader :url, :content_type

      def initialize(attributes = {})
        @url = attributes[:url]
        @content_type = attributes[:content_type]
      end

      def attachable_plain_text_representation(caption)
        "[#{caption || "Video"}]"
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
        if attachable = attachable_from_sgid(node["sgid"])
          attachable
        elsif attachable = ActionText::Attachables::ContentAttachment.from_node(node)
          attachable
        elsif attachable = ActionText::Attachables::RemoteImage.from_node(node)
          attachable
        elsif attachable = ActionText::Attachables::RemoteVideo.from_node(node)
          attachable
        else
          ActionText::Attachables::MissingAttachable
        end
      end
    end
  end
end

module ActionText
  module ContentHelper
    mattr_accessor(:sanitizer) { Rails::Html::Sanitizer.safe_list_sanitizer.new }
    mattr_accessor(:allowed_tags) do
      sanitizer.class.allowed_tags +
      [ActionText::Attachment::TAG_NAME, "figure", "figcaption", "video"]
    end
    mattr_accessor(:allowed_attributes) do
      sanitizer.class.allowed_attributes +
      ActionText::Attachment::ATTRIBUTES +
      %w(controls preload)
    end
    mattr_accessor(:scrubber)

    def render_action_text_content(content)
      self.prefix_partial_path_with_controller_namespace = false
      sanitize_action_text_content(render_action_text_attachments(content))
    end

    def sanitize_action_text_content(content)
      sanitizer.sanitize(content.to_html, tags: allowed_tags, attributes: allowed_attributes, scrubber: scrubber).html_safe
    end

    def render_action_text_attachments(content)
      content.render_attachments do |attachment|
        unless attachment.in?(content.gallery_attachments)
          attachment.node.tap do |node|
            node.inner_html = render(attachment, in_gallery: false).chomp
          end
        end
      end.render_attachment_galleries do |attachment_gallery|
        render(layout: attachment_gallery, object: attachment_gallery) do
          attachment_gallery.attachments.map do |attachment|
            attachment.node.inner_html = render(attachment, in_gallery: true).chomp
            attachment.to_html
          end.join.html_safe
        end.chomp
      end
    end
  end
end
