FactoryBot.define do
  factory :video do
    attachable { FactoryBot.create(:post) }
    token      { SecureRandom.urlsafe_base64(30) }
    key        { "uploads/#{SecureRandom.uuid}/video.mp4" }
  end
end
