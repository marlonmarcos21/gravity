# frozen_string_literal: true

module Paperclip
  class UrlGenerator
    def for(style_name, options)
      interpolated = attachment_options[:interpolator].interpolate(
        most_appropriate_url, @attachment, style_name
      )

      url = transform_url(interpolated, options)
      timestamp_as_needed(url, options)
    end

    private

    def transform_url(url, options)
      parts = url.split('/').reject do |part|
        part.blank? ||
          part == ENV['AWS_S3_BUCKET'] ||
          part == ENV['AWS_S3_HOST_NAME'] ||
          part.starts_with?('http')
      end

      new_url = "https://#{ENV['AWS_S3_BUCKET']}/#{parts.join('/')}"

      options[:escape] ? url_encode(new_url) : new_url
    end

    # Taken from URI.encode_www_form_component
    # https://ruby-doc.org/stdlib-2.7.2/libdoc/uri/rdoc/URI.html#method-c-encode_www_form_component
    # but including: '/' and ':' as a safe character that doesn't get encoded
    def url_encode(str, enc = nil)
      str = str.to_s.dup
      if str.encoding != Encoding::ASCII_8BIT
        if enc && enc != Encoding::ASCII_8BIT
          str.encode!(Encoding::UTF_8, invalid: :replace, undef: :replace)
          str.encode!(enc, fallback: ->(x) { "&##{x.ord};" })
        end
        str.force_encoding(Encoding::ASCII_8BIT)
      end
      str.gsub!(%r{[^*/\-:.0-9A-Z_a-z]}, URI::TBLENCWWWCOMP_)
      str.force_encoding(Encoding::US_ASCII)
    end
  end

  class UriAdapter < AbstractAdapter
    attr_reader :uri_tempfile

    def download_content
      opts = { read_timeout: Paperclip.options[:read_timeout] }.compact
      @uri_tempfile = @target.open(**opts)
    end
  end

  class HttpUrlProxyAdapter < UriAdapter
    def initialize(target, options = {})
      url = target == CGI.unescape(target) ? url_encode(target) : target
      super(URI(url), options)
    end
  end

  module Validators
    class AttachmentPresenceValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, _value)
        return if record.send("#{attribute}_file_name").present?

        record.errors.add(attribute, :blank, **options)
      end
    end

    class AttachmentContentTypeValidator < ActiveModel::EachValidator
      def mark_invalid(record, attribute, types)
        record.errors.add attribute, :invalid, **options.merge(types: types.join(', '))
      end
    end

    class AttachmentSizeValidator < ActiveModel::Validations::NumericalityValidator
      CHECK_METHOD_MAPPING = {
        less_than: :<,
        less_than_or_equal_to: :<=,
        greater_than: :>,
        greater_than_or_equal_to: :>=
      }.freeze

      def validate_each(record, base_attr_name, _value)
        attr_name = "#{base_attr_name}_file_size".to_sym
        value = record.send(:read_attribute_for_validation, attr_name)
        return if value.blank?

        options.slice(*AVAILABLE_CHECKS).each do |option, option_value|
          option_value = option_value.call(record) if option_value.is_a?(Proc)
          option_value = extract_option_value(option, option_value)
          next if value.send(CHECK_METHOD_MAPPING[option], option_value)

          error_message_key = options[:in] ? :in_between : option
          [attr_name, base_attr_name].each do |error_attr_name|
            record.errors.add(
              error_attr_name,
              error_message_key,
              filtered_options(value).merge(
                min: min_value_in_human_size(record),
                max: max_value_in_human_size(record),
                count: human_size(option_value)
              )
            )
          end
        end
      end
    end
  end
end

Paperclip::DataUriAdapter.register
Paperclip::HttpUrlProxyAdapter.register
