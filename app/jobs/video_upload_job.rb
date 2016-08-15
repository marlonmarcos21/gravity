class VideoUploadJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Video.create(args)
  end
end
