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
      str.gsub!(/[^*\/\-:.0-9A-Z_a-z]/, URI::TBLENCWWWCOMP_)
      str.force_encoding(Encoding::US_ASCII)
    end
  end
end
