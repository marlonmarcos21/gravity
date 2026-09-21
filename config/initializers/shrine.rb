require 'shrine'
require 'shrine/storage/s3'

s3_opts = S3::CLIENT_OPTIONS.merge(bucket: S3::PUBLIC_BUCKET_NAME, public: true)

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_opts),
  store: Shrine::Storage::S3.new(prefix: 'store', **s3_opts)
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :determine_mime_type

Shrine.plugin :url_options, store: { host: "https://#{S3::PUBLIC_BUCKET_HOST}" }
