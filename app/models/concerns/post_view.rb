module PostView
  extend ActiveSupport::Concern

  def embed_youtube
    html = Nokogiri::HTML.fragment(body)
    a_tags = html.search('a')

    return body if a_tags.empty?

    a_tags.each do |node|
      youtube_id = get_youtube_id(node.attributes['href'].value)
      next if youtube_id.blank?
      iframe = %(<br><br><iframe width="560" height="315" src="https://www.youtube.com/embed/#{youtube_id}" frameborder="0" allowfullscreen></iframe>)
      node.add_next_sibling iframe
    end

    html.to_html
  end

  private

  def get_youtube_id(url)
    return unless url =~ /youtube.com/ || url =~ /youtu\.be/

    uri = URI url
    return uri.path.sub(%r{^/}, '') if url =~ /youtu\.be/
    return unless uri.query

    query = CGI::parse uri.query
    query['v'].try(:first)
  end
end
