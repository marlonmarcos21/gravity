shared_context 'with_authentication' do
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
  end
end
