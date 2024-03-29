# == Schema Information
#
# Table name: posts
#
#  id           :integer          not null, primary key
#  body         :text
#  public       :boolean          default(FALSE)
#  published    :boolean          default(TRUE)
#  published_at :datetime
#  slug         :string
#  tsv_name     :tsvector
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#
# Indexes
#
#  index_posts_on_public    (public)
#  index_posts_on_tsv_name  (tsv_name) USING gin
#  index_posts_on_user_id   (user_id)
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Associations & Validations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_one :main_image }
    it { is_expected.to have_many :images }
    it { is_expected.to have_many :videos }
    it { is_expected.to have_many :likes }
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :user }
  end

  describe 'Callbacks' do
    let(:post) { FactoryBot.build(:post) }

    subject { post.save }

    describe '#strip_body' do
      before do
        post.body = '   text with spaces    '
      end

      it 'should strip white spaces' do
        subject
        expect(post.body).to eql('text with spaces')
      end
    end

    describe '#set_published_at' do
      before do
        Timecop.freeze
      end

      it 'should set current date and time as published_at date' do
        subject
        expect(post.published?).to eql(true)
        expect(post.published_at).to eql(Time.zone.now)
      end
    end
  end

  describe 'Instance methods' do
    before do
      Timecop.freeze '2016-08-24 23:39:12 +0800'
      @post = FactoryBot.create(:post)
    end

    describe '#date_meta' do
      it do
        expect(@post.date_meta).to eql('Wed, Aug 24, 2016 11:39')
      end
    end
  end
end
