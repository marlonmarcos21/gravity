module ApplicationHelper
  def render_meta_tags(model)
    meta = Meta.new
    meta.url = url_for(
      action: :show,
      controller: model.class.name.underscore.pluralize,
      only_path: false
    )

    if model.is_a?(Blog)
      meta.title       = strip_content!(model.title)
      meta.description = strip_content!(model.body)
      meta.type        = 'article'
      meta.image       = model.blog_media.order(:id).first.try(:source_url)
      meta.author      = model.user.name
    elsif model.is_a?(Event)
      content          = strip_content!(model.title)
      meta.title       = content
      meta.description = content
      meta.image       = model.og_image_source.presence || home_image
    else
      meta.title       = 'Gravity'
      meta.description = strip_content!(model.body)
      image            = model.images.first
      if image
        meta.image     = image.source_url(expires_in: 1.week.to_i)
        meta.url       = meta.image if image.gif?
      end
    end

    meta.image ||= home_image
    meta.image = meta.image.sub('https', 'http')

    content_for :meta_tags, meta.render
  end

  def home_image
    "https://#{ENV['AWS_S3_BUCKET']}/assets/home.jpg"
  end

  def loading_spinner_image
    "https://#{ENV['AWS_S3_BUCKET']}/assets/loading.gif"
  end

  def about_image
    "https://#{ENV['AWS_S3_BUCKET']}/assets/about.jpg"
  end

  def strip_content!(text)
    text = strip_tags(text).squish.truncate(150, omission: '...', separator: ' ')
    Nokogiri::HTML.parse(text).text
  end
end
