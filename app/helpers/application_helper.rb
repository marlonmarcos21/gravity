module ApplicationHelper
  BOOTSTRAP_FLASH_MSG = {
    success: 'alert-success',
    error:   'alert-error',
    alert:   'alert-block',
    notice:  'alert-info'
  }

  # def bootstrap_class_for(flash_type)
  #   BOOTSTRAP_FLASH_MSG.fetch(flash_type.to_sym, flash_type.to_s)
  # end

  # def flash_messages(opts = {})
  #   flash.each do |msg_type, message|
  #     concat(
  #       content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
  #         concat(content_tag(:button, '×'.html_safe, class: "close", data: { dismiss: 'alert' }))
  #         concat message
  #       end
  #     )
  #   end
  #   nil
  # end

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
