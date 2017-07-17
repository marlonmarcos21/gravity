require 'htmlentities'

module BlogView
  extend ActiveSupport::Concern

  include ActionView::Helpers::SanitizeHelper

  def stripped_teaser(length = 400)
    HTMLEntities.new.decode(
      sanitize(body, tags: [])
        .truncate(
          length,
          separator: ' ',
          omission: '...',
          escape: false
        )
    )
  end

  def html_formatted_teaser(length = 400)
    html_teaser = HTML_Truncator.truncate body, length, length_in_chars: true
    html        = Nokogiri::HTML.fragment(html_teaser)

    tags_to_remove = %w(img figcaption)
    tags_to_remove.each do |tag|
      html.search(tag).each do |node|
        node.remove if node.name == tag
      end
    end

    html.search('h1, h2, h3, h4, h5, h6').each do |node|
      node.name     = 'p'
      node.children = "<b>#{node.children}</b>"
    end

    html.search('a').each { |node| node.name = 'span' }

    html.to_s
  end
end
