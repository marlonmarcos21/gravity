FactoryGirl.define do
  factory :blog_medium do
    source_file_name    { 'test.jpg' }
    source_content_type { 'image/jpeg' }
    source_file_size    { 1024 }
    attachable          { FactoryGirl.create(:blog) }
    token               { SecureRandom.urlsafe_base64(30) }
  end
end
