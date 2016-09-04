module ApplicationHelper
  def custom_drop_down(name, opts = {})
    html_class = 'dropdown'
    html_class += " #{opts[:class]}" unless opts[:class].blank?
    content_tag :li, class: html_class do
      custom_drop_down_link(name, opts) + custom_drop_down_list { yield }
    end
  end

  def render_meta_tags(model)
    meta.description = strip_content!(model.body)
    meta.url = url_for(action: :show, controller: model.class.name.underscore.pluralize, only_path: false)
    if model.is_a?(Blog)
      meta.title = strip_content!(model.title)
      meta.type = 'article'
      meta.image = model.blog_media.first.try(:source_url)
      meta.author = model.user.name
    else
      meta.title = 'Gravity'
      meta.image = model.images.first.try(:source_url, :main, 1.week.to_i)
    end
    meta.image = 'http://static-prod.gravity.ph/assets/home.jpg' unless meta.image
    meta.image = meta.image.sub('https', 'http')
    content_for :meta_tags, meta.render
  end

  private

  def meta
    @meta ||= Meta.new
  end

  def custom_drop_down_link(name, opts = {})
    path = opts[:path] || '#'
    link_to(custom_name_and_caret(name), path, class: "dropdown-toggle #{opts[:class]}", 'data-toggle' => 'dropdown')
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
