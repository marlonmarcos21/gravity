FactoryBot.define do
  factory :video do
    source_file_name    { 'test.mp4' }
    source_content_type { 'video/mp4' }
    source_file_size    { 1024 }
    attachable          { FactoryBot.create(:post) }
    token               { SecureRandom.urlsafe_base64(30) }
  end
end
