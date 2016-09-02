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
      meta.image = model.images.first.try(:source_url, :main, 1.day.to_i)
    end
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
    "#{name} #{content_tag(:b, class: 'caret') {}}".html_safe
  end

  def strip_content!(text)
    text = strip_tags(text).split('. ')[0..1].join('. ').squish
    text = text.truncate(150, omission: '...', separator: ' ')
    Nokogiri::HTML.parse(text).text
  end
end
