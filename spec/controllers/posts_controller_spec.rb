require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:token) { SecureRandom.urlsafe_base64(30) }
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

  describe 'GET #more_published_posts' do
    it 'assigns all posts as @posts' do
      xhr :get, :more_published_posts, format: :js
      expect(response.code).to eq('200')
      expect(response).to render_template(:more_published_posts)
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
      describe 'normal http request' do
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

        context 'with attached media' do
          subject { post :create, post: @post_params, media_token: token }

          before do
            @post_params = valid_attributes
            @image = FactoryGirl.create(:image, token: token)
            @video = FactoryGirl.create(:video, token: token)
          end

          it 'created post should have image and video' do
            subject
            last_post = Post.last
            expect(last_post.images).to include(@image)
            expect(last_post.videos).to include(@video)
          end
        end

        context 'with invalid params' do
          before do
            @post_params = valid_attributes
            @post_params[:body] = nil
          end

          it 'does not create the post' do
            expect { subject }.not_to change(Post, :count)
          end

          it 'sets alert flash' do
            subject
            expect(flash[:alert]).to eq('Error creating post')
          end

          it 'renders new template' do
            expect(subject).to render_template(:new)
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

      describe 'xhr request' do
        subject { xhr :post, :create, post: @post_params, format: :js }

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

          it 'renders new_post template' do
            expect(subject).to render_template(:new_post)
          end
        end

        context 'with invalid params' do
          before do
            @post_params = valid_attributes
            @post_params[:body] = nil
          end

          it 'does not create the post' do
            expect { subject }.not_to change(Post, :count)
          end

          it 'sets alert flash' do
            subject
            expect(flash[:alert]).to eq('Error creating post')
          end

          it 'renders nothing' do
            subject
            expect(response.body).to be_blank
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

        context 'with invalid params' do
          before do
            @new_attributes = { body: nil }
          end

          it 'does not change the post body' do
            expect { subject }.not_to change { @post.reload.body }
          end

          it 'renders edit template' do
            expect(subject).to render_template(:edit)
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

      describe 'PATCH #editable' do
        subject { xhr :patch, :editable, @editable_params }

        context 'with valid params' do
          before do
            @editable_params = { id: @post.id, name: 'body', value: 'new body', format: :json }
          end

          it 'updates the requested post' do
            expect { subject }.to change { @post.reload.body }.to('new body')
          end

          it 'json response should include message, id and content' do
            subject
            expect(JSON.parse(response.body)).to eq({"message"=>"success", "post_id"=>@post.id, "content"=>"new body", "private"=>false})
          end
        end

        context 'with invalid params' do
          before do
            @editable_params = { id: @post.id, name: 'body', value: nil, format: :json }
          end

          it 'does not change the post body' do
            expect { subject }.not_to change { @post.reload.body }
          end

          it 'sets alert flash' do
            subject
            expect(flash[:alert]).to eq('Post update failed!')
          end

          it 'response code with 422' do
            subject
            expect(response.code).to eq('422')
          end
        end

        context 'with unpermitted params' do
          before do
            @editable_params = { id: @post.id, name: 'tae', value: 'ka', format: :json }
          end

          it 'raises unpermitted parameters' do
            expect { subject }.to raise_error(ActiveRecord::UnknownAttributeError)
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

      describe '#upload_media' do
        subject do
          VCR.use_cassette 's3/upload', match_requests_on: [:host, :method], record: :new_episodes do
            xhr :post,
                :upload_media,
                media_token: @token,
                post: { media_attributes: { '0' => { source: fixture_file_upload('files/test.jpg', 'image/jpg') } } },
                format: :json
          end
        end

        describe 'successful upload' do
          before do
            @token = token
          end

          it 'creates a new media for the post' do
            expect { subject }.to change(Image, :count).by(1)
          end
        end

        describe 'failed upload' do
          it 'does not create a new media for the post' do
            expect { subject }.not_to change(Image, :count)
          end

          it 'returns error' do
            subject
            expect(response.code).to eq('422')
            expect(JSON.parse(response.body)).to eq({ 'message' => 'failed' })
          end
        end
      end

      describe '#remove_modia' do
        let(:image) { FactoryGirl.create(:image, token: token) }

        subject do
          VCR.use_cassette 's3/destroy', match_requests_on: [:host, :method], record: :new_episodes do
            xhr :post,
                :remove_media,
                media_token: @token,
                source_file_name: image.source_file_name,
                format: :json
          end
        end

        before do
          image
        end

        describe 'successful removal' do
          before do
            @token = token
          end

          it 'removes the media for the post' do
            expect { subject }.to change(Image, :count).by(-1)
            expect(Image.find_by_id(image.id)).to be_nil
          end
        end

        describe 'failed removal' do
          it 'does not delete the media for the post' do
            expect { subject }.not_to change(Image, :count)
            expect(image.reload).to eq(image)
          end

          it 'returns error' do
            subject
            expect(response.code).to eq('422')
            expect(JSON.parse(response.body)).to eq({ 'message' => 'failed' })
          end
        end
      end
    end
  end
end
