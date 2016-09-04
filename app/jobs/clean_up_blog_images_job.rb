class CleanUpBlogImagesJob < ActiveJob::Base
  queue_as :default

  def perform(blog_id)
    blog = Blog.find blog_id
    file_names    = get_blog_images(blog)
    unused_images = BlogMedium.where(attachable: blog)
                              .where.not(source_file_name: file_names)

    unused_images.delete_all if unused_images.exists?
  end

  private

  def get_blog_images(blog)
    html    = Nokogiri::HTML(blog.body)
    sources = html.xpath "//img/@src"
    sources.map do |attr|
      src = attr.value
      uri = URI src
      uri.path.split('/').last
    end
  end
end
