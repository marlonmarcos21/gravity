module ApplicationHelper
  def render_meta_tags(model)
    meta.description = strip_content!(model.body)
    meta.url = url_for(
      action: :show,
      controller: model.class.name.underscore.pluralize,
      only_path: false
    )

    if model.is_a?(Blog)
      meta.title = strip_content!(model.title)
      meta.type = 'article'
      meta.image = model.blog_media.order(:id).first.try(:source_url)
      meta.author = model.user.name
    else
      meta.title = 'Gravity'
      image = model.images.first
      if image
        meta.image = image.source_url(expires_in: 1.week.to_i)
        meta.url = meta.image if image.gif?
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

  def custom_drop_down(name, opts = {})
    html_class = 'dropdown'
    html_class += " #{opts[:class]}" unless opts[:class].blank?
    content_tag :li, class: html_class do
      custom_drop_down_link(name, opts) + custom_drop_down_list { yield }
    end
  end

  private

  def meta
    @meta ||= Meta.new
  end

  def custom_drop_down_link(name, opts = {})
    path = opts[:path] || '#'
    link_to(
      custom_name_and_caret(name),
      path,
      class: "dropdown-toggle #{opts[:class]}",
      'data-toggle' => 'dropdown'
    )
  end

  def custom_drop_down_list(&block)
    content_tag :ul, class: 'dropdown-menu', &block
  end

  def custom_name_and_caret(name)
    "#{name} #{content_tag(:b, nil, class: 'caret')}"
  end

  def strip_content!(text)
    text = strip_tags(text).squish.truncate(150, omission: '...', separator: ' ')
    Nokogiri::HTML.parse(text).text
  end
end
