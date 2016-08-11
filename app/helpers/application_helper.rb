module ApplicationHelper
  def embed_youtube(content)
    uris = URI.extract(content, 'https')
    return auto_link(content) if uris.empty?

    uris.map do |uri|
      youtube_id = get_youtube_id uri
      next if youtube_id.blank?
      replace_with = %Q{<iframe width="560" height="315" src="http://www.youtube.com/embed/#{youtube_id}" frameborder="0" allowfullscreen></iframe>} + "\n"
      content.sub!(uri, replace_with)
    end

    content
  end

  def custom_drop_down(name, opts = {})
    html_class = 'dropdown'
    html_class += " #{opts[:class]}" unless opts[:class].blank?
    content_tag :li, class: html_class do
      custom_drop_down_link(name, opts) + custom_drop_down_list { yield }
    end
  end

  private

  def get_youtube_id(youtube_url)
    if youtube_url =~ /youtube/
      uri = URI youtube_url
      query = CGI::parse uri.query
      query['v'].first if query.key?('v')
    elsif youtube_url =~ /youtu\.be/
      uri = URI youtube_url
      uri.path.sub(/^\//, '')
    end
  end

  def custom_drop_down_link(name, opts = {})
    path = opts[:path] || '#'
    link_to(custom_name_and_caret(name), path, class: "dropdown-toggle #{opts[:class]}", 'data-toggle' => 'dropdown')
  end

  def custom_drop_down_list(&block)
    content_tag :ul, class: 'dropdown-menu', &block
  end

  def custom_name_and_caret(name)
    "#{name} #{content_tag(:b, class: 'caret') {}}".html_safe
  end
end
