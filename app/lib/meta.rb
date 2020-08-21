class Meta
  include ActionView::Helpers::TagHelper

  attr_accessor :title, :type, :description, :url, :image, :author

  def render
    inject_meta_tags.join("\n").html_safe
  end

  private

  def meta(property, content, property_type = 'og')
    tag.meta(property: "#{property_type}:#{property}", content: content)
  end

  def inject_meta_tags(property_type = 'og')
    tags = []
    instance_variables.each do |attr_name|
      value = instance_variable_get(attr_name)
      next if value.nil?

      value = Array[value].flatten
      value.each do |content|
        tags << meta(attr_name[1..], content, property_type)
      end
    end

    tags
  end
end
