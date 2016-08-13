module PostView
  extend ActiveSupport::Concern

  def embed_youtube
    content = body
    html = Nokogiri::HTML.fragment(content)
    a_tags = html.search('a')

    return content if a_tags.empty?

    a_tags.map do |node|
      youtube_id = get_youtube_id(node.attributes['href'].value)
      next if youtube_id.blank?
      replace_with = "#{node.to_s}<br /><br />" + %Q{<iframe width="560" height="315" src="http://www.youtube.com/embed/#{youtube_id}" frameborder="0" allowfullscreen></iframe>} + "<br /><br />"
      content.sub!(node.to_s, replace_with)
    end

    content
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
end
