require 'shrine'
require 'shrine/storage/s3'

# Connection settings come from S3::CLIENT_OPTIONS (config/initializers/s3.rb)
# so Shrine, Paperclip and BUCKET all talk to the gateway the same way.
#
# public: true is deliberate. trix_upload.js writes the URL returned by
# RecipeMediaController#create straight into the Action Text body, where it is
# stored forever -- a presigned URL would expire and break every saved recipe.
# The gateway therefore has to serve the store/ prefix anonymously.
s3_opts = S3::CLIENT_OPTIONS.merge(bucket: S3::BUCKET_NAME, public: true)

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_opts),
  store: Shrine::Storage::S3.new(prefix: 'store', **s3_opts)
}

Shrine.plugin :activerecord           # loads Active Record integration
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data    # extracts metadata for assigned cached files
Shrine.plugin :determine_mime_type    # determine mime_type

# No :upload_options acl here -- the gateway answers the ACL APIs with
# NotImplemented, so object visibility is a gateway-side setting.
Shrine.plugin :url_options, store: { host: "https://#{ENV['AWS_S3_PUBLIC_HOST']}" }
