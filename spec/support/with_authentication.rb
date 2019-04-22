shared_context 'with_authentication' do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end
end
