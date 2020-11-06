BUCKET = Aws::S3::Resource.new(
  access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_ACCESS_SECRET'],
  region:            ENV['AWS_S3_REGION']
).bucket(ENV['AWS_S3_BUCKET'])
