module PostView
  extend ActiveSupport::Concern

  def embed_youtube
    html = Nokogiri::HTML.fragment(body)
    a_tags = html.search('a')

    return body if a_tags.empty?

    a_tags.map do |node|
      youtube_id = get_youtube_id(node.attributes['href'].value)
      next if youtube_id.blank?
      replace_with = "#{node}<br /><br />" + %(<iframe width="560" height="315" src="https://www.youtube.com/embed/#{youtube_id}" frameborder="0" allowfullscreen></iframe>) + '<br /><br />'
      body.sub!(node.to_s, replace_with)
    end.last
  end

  private

  def get_youtube_id(youtube_url)
    if youtube_url =~ /youtube/
      uri = URI youtube_url
      query = CGI::parse uri.query
      query['v'].first if query.key?('v')
    elsif youtube_url =~ /youtu\.be/
      uri = URI youtube_url
      uri.path.sub(%r{^/}, '')
    end
  end
end
