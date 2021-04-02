require 'shrine'
require 'shrine/storage/s3'

s3_opts = {
  bucket: ENV['AWS_S3_BUCKET'],
  region: ENV['AWS_S3_REGION'],
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_ACCESS_SECRET']
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_opts),
  store: Shrine::Storage::S3.new(prefix: 'store', **s3_opts)
}

Shrine.plugin :activerecord           # loads Active Record integration
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data    # extracts metadata for assigned cached files
Shrine.plugin :determine_mime_type    # determine mime_type