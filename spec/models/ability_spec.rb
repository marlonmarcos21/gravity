require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  subject { Ability.new(@user) }

  describe 'Post' do
    let(:post) { FactoryBot.create(:post, user: user, public: true) }
    let(:private_post) { FactoryBot.create(:post, user: user) }

    describe 'more_published_posts' do
      context 'when anonymous' do
        it { should be_able_to(:more_published_posts, post) }
      end

      context 'when logged in' do
        before do
          @user = user
        end

        it { should be_able_to(:more_published_posts, post) }
      end
    end

    describe 'read' do
      context 'when anonymous' do
        it { should be_able_to(:read, post) }
        it { should_not be_able_to(:read, private_post) }
      end

      context 'when logged in and owner' do
        before do
          @user = user
        end

        it { should be_able_to(:read, post) }
        it { should be_able_to(:read, private_post) }
      end

      context 'when logged in and other user' do
        before do
          @user = other_user
        end

        it { should be_able_to(:read, post) }
        it { should_not be_able_to(:read, private_post) }

        describe 'when poster is friends with other user' do
          let(:friend_request) do
            FactoryBot.create(:friend_request,
                               user: user,
                               requester: other_user)
          end

          before do
            FactoryBot.create(:friend, friend_request: friend_request)
            friend2 = FactoryBot.create(:friend)
            friend2.update(friend_request: friend_request, user: other_user, friend: user)
          end

          it { should be_able_to(:read, private_post) }
        end
      end
    end

    describe 'update, destroy & editable' do
      context 'when anonymous' do
        %i(update destroy editable).each do |action|
          it { should_not be_able_to(action, post) }
        end
      end

      context 'when poster' do
        before do
          @user = user
        end

        %i(update destroy editable).each do |action|
          it { should be_able_to(action, post) }
        end
      end

      context 'when other_user' do
        before do
          @user = other_user
        end

        %i(update destroy editable).each do |action|
          it { should_not be_able_to(action, post) }
        end
      end
    end

    describe 'create, media_upload_callback & remove_media' do
      let(:new_post) { FactoryBot.build(:post) }

      context 'when anonymous' do
        %i(create media_upload_callback remove_media presigned_url pre_post_check).each do |action|
          it { should_not be_able_to(action, new_post) }
        end
      end

      context 'when poster' do
        before do
          @user = user
        end

        %i(create media_upload_callback remove_media presigned_url pre_post_check).each do |action|
          it { should be_able_to(action, new_post) }
        end
      end

      context 'when other_user' do
        before do
          @user = other_user
        end

        %i(create media_upload_callback remove_media presigned_url pre_post_check).each do |action|
          it { should be_able_to(action, new_post) }
        end
      end
    end
  end

  describe 'Blog' do
    let(:blog) { FactoryBot.create(:blog, user: user) }
    let(:published_blog) { FactoryBot.create(:blog, user: user, published: true) }

    describe 'more_published_blogs' do
      context 'when anonymous' do
        it { should be_able_to(:more_published_blogs, blog) }
      end

      context 'when logged in' do
        before do
          @user = user
        end

        it { should be_able_to(:more_published_blogs, blog) }
      end
    end

    describe 'read' do
      context 'when anonymous' do
        it { should_not be_able_to(:read, blog) }
        it { should be_able_to(:read, published_blog) }
      end

      context 'when owner' do
        before do
          @user = user
        end

        it { should be_able_to(:read, blog) }
        it { should be_able_to(:read, published_blog) }
      end

      context 'when other user' do
        before do
          @user = other_user
        end

        it { should_not be_able_to(:read, blog) }
        it { should be_able_to(:read, published_blog) }
      end
    end

    describe 'update, destroy, publish & unpublish' do
      context 'when anonymous' do
        %i(update destroy publish unpublish).each do |action|
          it { should_not be_able_to(action, blog) }
        end
      end

      context 'when owner' do
        before do
          @user = user
        end

        %i(update destroy publish unpublish).each do |action|
          it { should be_able_to(action, blog) }
        end
      end

      context 'when other user' do
        before do
          @user = other_user
        end

        %i(update destroy publish unpublish).each do |action|
          it { should_not be_able_to(action, blog) }
        end
      end
    end

    describe 'create & tinymce_assets' do
      let(:new_blog) { FactoryBot.build(:blog) }

      context 'when anonymous' do
        %i(create tinymce_assets).each do |action|
          it { should_not be_able_to(action, new_blog) }
        end
      end

      context 'when logged in' do
        before do
          @user = user
        end

        %i(create tinymce_assets).each do |action|
          it { should be_able_to(action, new_blog) }
        end
      end
    end
  end

  describe 'User' do
    describe 'read, more_published_posts & more_published_blogs' do
      context 'when anonymous' do
        %i(read more_published_posts more_published_blogs).each do |action|
          it { should be_able_to(action, user) }
        end
      end

      context 'when logged in' do
        before do
          @user = user
        end

        %i(read more_published_posts more_published_blogs).each do |action|
          it { should be_able_to(action, user) }
        end
      end
    end

    describe 'update & more_drafted_blogs' do
      context 'when anonymous' do
        %i(update more_drafted_blogs).each do |action|
          it { should_not be_able_to(action, user) }
        end
      end

      context 'when current_user is user' do
        before do
          @user = user
        end

        %i(update more_drafted_blogs).each do |action|
          it { should be_able_to(action, user) }
        end
      end

      context 'when other user' do
        before do
          @user = other_user
        end

        %i(update more_drafted_blogs).each do |action|
          it { should_not be_able_to(action, user) }
        end
      end
    end

    describe 'send_friend_request' do
      context 'when anonymous' do
        it { should_not be_able_to(:send_friend_request, user) }
      end

      context 'when same user' do
        before do
          @user = user
        end

        it { should_not be_able_to(:send_friend_request, user) }
      end

      context 'when other user' do
        before do
          @user = other_user
        end

        it { should be_able_to(:send_friend_request, user) }

        context 'when already friends' do
          before do
            friend_request = FactoryBot.create(:friend_request, user: other_user, requester: user)
            FactoryBot.create(:friend, friend_request: friend_request)
          end

          it { should_not be_able_to(:send_friend_request, user) }
        end

        context 'when already have existing request' do
          before do
            FactoryBot.create(:friend_request, user: user, requester: other_user)
          end

          it { should_not be_able_to(:send_friend_request, user) }
        end
      end
    end

    describe 'accept_friend_request' do
      context 'when anonymous' do
        it { should_not be_able_to(:accept_friend_request, user) }
      end

      context 'when same user' do
        before do
          @user = user
        end

        it { should_not be_able_to(:accept_friend_request, user) }
      end

      context 'when other user' do
        before do
          @user = other_user
        end

        it { should_not be_able_to(:accept_friend_request, user) }

        context 'when have existing request' do
          before do
            @friend_request = FactoryBot.create(:friend_request, user: other_user, requester: user)
          end

          it { should be_able_to(:accept_friend_request, user) }

          context 'when already friends' do
            before do
              FactoryBot.create(:friend, friend_request: @friend_request)
            end

            it { should_not be_able_to(:accept_friend_request, user) }
          end
        end
      end
    end

    describe 'cancel_friend_request' do
      context 'when anonymous' do
        it { should_not be_able_to(:cancel_friend_request, user) }
      end

      context 'when same user' do
        before do
          @user = user
        end

        it { should_not be_able_to(:cancel_friend_request, user) }
      end

      context 'when other user' do
        before do
          @user = other_user
        end

        it { should_not be_able_to(:cancel_friend_request, user) }

        context 'when have existing request' do
          before do
            @friend_request = FactoryBot.create(:friend_request, user: user, requester: other_user)
          end

          it { should be_able_to(:cancel_friend_request, user) }

          context 'when already friends' do
            before do
              friend_request = FactoryBot.create(:friend_request, user: other_user, requester: user)
              FactoryBot.create(:friend, friend_request: friend_request)
            end

            it { should_not be_able_to(:cancel_friend_request, user) }
          end
        end
      end
    end

    describe 'reject_friend_request' do
      context 'when anonymous' do
        it { should_not be_able_to(:reject_friend_request, user) }
      end

      context 'when same user' do
        before do
          @user = user
        end

        it { should_not be_able_to(:reject_friend_request, user) }
      end

      context 'when other user' do
        before do
          @user = other_user
        end

        it { should_not be_able_to(:reject_friend_request, user) }

        context 'when have existing request' do
          before do
            @friend_request = FactoryBot.create(:friend_request, user: other_user, requester: user)
          end

          it { should be_able_to(:reject_friend_request, user) }

          context 'when already friends' do
            before do
              FactoryBot.create(:friend, friend_request: @friend_request)
            end

            it { should_not be_able_to(:reject_friend_request, user) }
          end
        end
      end
    end
  end

  describe 'Comment' do
    let(:comment) { FactoryBot.create(:comment, user: user) }

    describe 'create' do
      let(:new_comment) { FactoryBot.build(:comment) }

      context 'when anonymous' do
        it { should_not be_able_to(:create, new_comment) }
      end

      context 'when logged in' do
        before do
          @user = user
        end

        it { should be_able_to(:create, new_comment) }
      end
    end

    describe 'destroy' do
      context 'when anonymous' do
        it { should_not be_able_to(:destroy, comment) }
      end

      context 'when commenter' do
        before do
          @user = user
        end

        it { should be_able_to(:destroy, comment) }
      end

      context 'when other user' do
        before do
          @user = other_user
        end

        it { should_not be_able_to(:destroy, comment) }

        context 'when the other user is the owner of the commentable' do
          before do
            comment.commentable.update(user: other_user)
          end

          it { should be_able_to(:destroy, comment) }
        end
      end
    end

    describe 'editable' do
      context 'when anonymous' do
        it { should_not be_able_to(:editable, comment) }
      end

      context 'when commenter' do
        before do
          @user = user
        end

        it { should be_able_to(:editable, comment) }
      end

      context 'when other user' do
        before do
          @user = other_user
        end

        it { should_not be_able_to(:editable, comment) }

        context 'when the other user is the owner of the commentable' do
          before do
            comment.commentable.update(user: other_user)
          end

          it { should_not be_able_to(:editable, comment) }
        end
      end
    end
  end
end
