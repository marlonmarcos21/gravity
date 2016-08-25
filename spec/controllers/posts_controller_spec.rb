require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:valid_attributes) { { body: 'Post body'  } }
  let(:unpermitted_attributes) { { tae: 'ka'  } }

  before do
    @post = FactoryGirl.create(:post)
  end

  describe 'GET #index' do
    it 'assigns all posts as @posts' do
      get :index
      expect(assigns(:posts)).to eq([@post])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested post as @post' do
      get :show, id: @post.id
      expect(assigns(:post)).to eq(@post)
    end
  end

  describe 'only for authenticated users' do
    include_context 'with_authentication'

    describe 'GET #new' do
      it 'assigns a new post' do
        get :new, params: {}
        expect(assigns(:post)).to be_a_new(Post)
      end
    end

    describe 'POST #create' do
      subject { post :create, post: @post_params }

      context 'with valid params' do
        before do
          @post_params = valid_attributes
        end

        it 'creates a new Post' do
          expect { subject }.to change(Post, :count).by(1)
        end

        it 'should be owned by the current_user' do
          subject
          expect(Post.last.user).to eq(user)
        end

        it 'redirects to the created post' do
          subject
          expect(response).to redirect_to(Post.last)
        end
      end

      context 'with unpermitted params' do
        before do
          @post_params = unpermitted_attributes
        end

        it 'raises unpermitted parameters' do
          expect { subject }.to raise_error(ActionController::UnpermittedParameters)
        end
      end
    end

    describe 'actions to own post' do
      before do
        @post.update_attribute :user, user
      end

      describe 'GET #edit' do
        it 'assigns the requested post as @post' do
          get :edit, id: @post.id
          expect(assigns(:post)).to eq(@post)
        end
      end

      describe 'PATCH #update' do
        subject { patch :update, id: @post.id, post: @new_attributes }

        context 'with valid params' do
          before do
            @new_attributes = { body: 'new body' }
          end

          it 'updates the requested post' do
            expect { subject }.to change { @post.reload.body }.to('new body')
          end

          it 'redirects to the post' do
            subject
            expect(response).to redirect_to(@post)
          end
        end

        context 'with unpermitted params' do
          before do
            @new_attributes = unpermitted_attributes
          end

          it 'raises unpermitted parameters' do
            expect { subject }.to raise_error(ActionController::UnpermittedParameters)
          end
        end
      end

      describe 'DELETE #destroy' do
        subject { delete :destroy, id: @post.id }

        it 'destroys the requested post' do
          expect { subject }.to change(Post, :count).by(-1)
        end

        it 'redirects to the posts list' do
          subject
          expect(response).to redirect_to(posts_url)
        end
      end
    end
  end
end
