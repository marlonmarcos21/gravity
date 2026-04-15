module PostView
  extend ActiveSupport::Concern

  def embed_videos
    html = Nokogiri::HTML.fragment(body)
    a_tags = html.search('a')
    return body if a_tags.empty?

    embed_youtube(a_tags)
    embed_tiktok(a_tags)

    html.to_html
  end

  private

  def embed_youtube(a_tags)
    a_tags.each do |node|
      youtube_id = get_youtube_id(node.attributes['href'].value)
      next if youtube_id.blank?

      iframe = '<br><br><iframe width="560" height="315" '\
        "src=\"https://www.youtube.com/embed/#{youtube_id}\""\
        'frameborder="0" allowfullscreen></iframe>'

      node.add_next_sibling iframe
    end
  end

  def embed_tiktok(a_tags)
    a_tags.each do |node|
      tiktok_data = get_tiktok_data(node.attributes['href'].value)
      next if tiktok_data.blank?

      cite = "https://www.tiktok.com/#{tiktok_data[:user_name]}/video/#{tiktok_data[:video_id]}"

      embed = <<~HTML
        <blockquote class="tiktok-embed" cite="#{cite}" data-video-id="#{tiktok_data[:video_id]}" style="max-width: 605px; min-width: 325px;">
          <section>
            <a target="_blank" title="@chibi.dango3" href="https://www.tiktok.com/#{tiktok_data[:user_name]}?refer=embed">
              #{tiktok_data[:user_name]}
            </a>
          </section>
        </blockquote>
      HTML

      node.add_next_sibling embed
    end
  end

  def get_youtube_id(url)
    return unless url =~ /youtube.com/ || url =~ /youtu\.be/

    uri = URI url
    return uri.path.sub(%r{^/}, '') if url =~ /youtu\.be/
    return unless uri.query

    query = CGI.parse uri.query
    query['v'].try(:first)
  end

  def get_tiktok_data(url)
    return unless url =~ /tiktok.com/

    uri = URI url
    path_parts = uri.path.split('/').compact_blank
    return unless path_parts.size == 3 && path_parts[1] == 'video'

    user_name = path_parts.first
    video_id = path_parts.last
    return unless user_name.starts_with?('@')

    { user_name: user_name, video_id: video_id }
  end
end
