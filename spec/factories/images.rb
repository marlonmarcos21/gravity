FactoryGirl.define do
  factory :image do
    source_file_name    { 'test.jpg' }
    source_content_type { 'image/jpeg' }
    source_file_size    { 1024 }
    attachable          { FactoryGirl.create(:post) }
    token               { SecureRandom.urlsafe_base64(30) }
  end
end
