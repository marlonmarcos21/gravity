class DatePickerInput < SimpleForm::Inputs::StringInput
  def input
    value = input_html_options[:value].try(:in_time_zone)
    value ||= object.send(attribute_name) if object.respond_to? attribute_name
    input_html_options[:value] ||= value.presence.try(:strftime, '%m/%d/%Y')
    input_html_classes << "datepicker"
    super
  end
end
