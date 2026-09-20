module S3
  ENDPOINT = ENV['AWS_S3_ENDPOINT'].presence
  # Private bucket: objects are only reachable through presigned URLs.
  BUCKET_NAME = ENV['AWS_S3_BUCKET'].presence
  # Public bucket: served anonymously, so URLs are stable and never expire.
  # Blog media and profile photos live here.
  PUBLIC_BUCKET_NAME = ENV['AWS_S3_PUBLIC_BUCKET'].presence

  # Addressing is virtual-host, so the bucket name is the host label.
  PUBLIC_BUCKET_HOST = PUBLIC_BUCKET_NAME && ENDPOINT &&
                       "#{PUBLIC_BUCKET_NAME}.#{URI(ENDPOINT).host}"

  # aws-sdk-s3 >= 1.178 sends CRC32 integrity headers on every upload and
  # validates them on download by default. Third-party gateways generally do
  # not implement those, so only send/check them when the API actually requires it.
  CLIENT_OPTIONS = {
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_ACCESS_SECRET'],
    region: ENV['AWS_S3_REGION'],
    endpoint: ENDPOINT,
    force_path_style: false,
    request_checksum_calculation: 'when_required',
    response_checksum_validation: 'when_required'
  }.compact.freeze

  # Extra options merged into the Aws::S3::Resource that Paperclip builds itself
  # (Paperclip only reads credentials/region from config/s3.yml).
  PAPERCLIP_OPTIONS = {
    storage: :s3,
    s3_credentials: Rails.root.join('config/s3.yml'),
    s3_region: ENV['AWS_S3_REGION'],
    s3_protocol: :https,
    s3_host_name: ENV['AWS_S3_PUBLIC_HOST'],
    s3_options: {
      endpoint: ENDPOINT,
      force_path_style: false,
      request_checksum_calculation: 'when_required',
      response_checksum_validation: 'when_required'
    }.compact
  }.freeze

  # Same connection, different bucket. `bucket:` overrides the one in
  # config/s3.yml, and s3_host_alias + :s3_alias_url make Paperclip emit
  # https://<public bucket host>/<key> -- an unsigned, non-expiring URL, which is
  # the point of this bucket. Without the alias Paperclip would build
  # <bucket>.<s3_host_name>, i.e. static-public.static-public.gravity.ph.
  # :path must be given explicitly: Paperclip only derives it when :url is *not*
  # one of the :s3_*_url styles, so with :s3_alias_url the default path is left
  # as ":rails_root/public:url" and interpolating it recurses
  # (Paperclip::Errors::InfiniteInterpolationError). This value is the same key
  # layout Paperclip would have derived, so existing objects keep their keys.
  PUBLIC_PAPERCLIP_OPTIONS = PAPERCLIP_OPTIONS.merge(
    bucket: PUBLIC_BUCKET_NAME,
    s3_host_name: PUBLIC_BUCKET_HOST,
    s3_host_alias: PUBLIC_BUCKET_HOST,
    url: ':s3_alias_url',
    path: '/:class/:attachment/:id_partition/:style/:filename'
  ).freeze

  module_function

  # Unsigned URL for an object in the bucket, served over the gateway's own
  # public host. This is what user uploads (profile photos) use -- they live in
  # the bucket, so they have to be addressed on the host that fronts it.
  def public_url(key)
    "https://#{ENV['AWS_S3_PUBLIC_HOST']}/#{key.to_s.sub(%r{\A/}, '')}"
  end

  # Unsigned, non-expiring URL for an object in the PUBLIC bucket. Everything
  # served anonymously goes through here: site chrome, the default avatar,
  # blog media and profile photos.
  def public_bucket_url(key)
    "https://#{PUBLIC_BUCKET_HOST}/#{key.to_s.sub(%r{\A/}, '')}"
  end

  # Presigned GET, normalised to https and without an explicit port.
  def presigned_url(key, expires_in: 3_600)
    uri = URI(BUCKET.object(key).presigned_url(:get, expires_in: expires_in.to_i))
    uri.port = nil
    uri.scheme = 'https'
    uri.to_s
  end
end

BUCKET = Aws::S3::Resource.new(**S3::CLIENT_OPTIONS).bucket(S3::BUCKET_NAME)
PUBLIC_BUCKET = S3::PUBLIC_BUCKET_NAME &&
                Aws::S3::Resource.new(**S3::CLIENT_OPTIONS).bucket(S3::PUBLIC_BUCKET_NAME)
