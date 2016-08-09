module ApplicationHelper
  def custom_drop_down(name, opts = {})
    html_class = 'dropdown'
    html_class += " #{opts[:class]}" unless opts[:class].blank?
    content_tag :li, class: html_class do
      custom_drop_down_link(name, opts) + custom_drop_down_list { yield }
    end
  end

  private

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
