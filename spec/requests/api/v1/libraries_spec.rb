require 'rails_helper'

RSpec.describe 'Api::V1::Libraries', type: :request do
  before do
    Library.delete_all
    create(:artist, id: 1)
    create(:style, id: 1)
    create(:user, id: 1)
    create(:painting, artist_id: 1, style_id: 1, id: 1)
    create(:painting, artist_id: 1, style_id: 1, id: 2)
  end

  let(:user) { User.find(1) }

  context 'when user is not logged' do
    describe 'POST /create' do
      it 'returns an unauthorized message' do
        post '/api/v1/users/library/create'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE /destroy' do
      it 'returns an unauthorized message' do
        delete '/api/v1/users/library/destroy'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PATCH /add_paintings' do
      it 'returns an unauthorized message' do
        patch '/api/v1/users/library/add_paintings'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PATCH /remove_paintings' do
      it 'returns an unauthorized message' do
        patch '/api/v1/users/library/remove_paintings'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'when user is logged' do
    before do
      sign_in user
    end

    describe 'POST /create' do
      context 'when user already has a library' do
        before do
          create(:library, user_id: user.id)
        end

        it 'throws exception response' do
          post '/api/v1/users/library/create'
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when user does not have a library' do
        it 'returns successful response' do
          post '/api/v1/users/library/create'
          expect(response).to have_http_status(:created)
        end

        it 'creates library' do
          post '/api/v1/users/library/create'
          expect(user.library).not_to be_nil
        end
      end

      context 'when an array is passed as parameter' do
        it 'creates a library with reference to the painting_ids' do
          post '/api/v1/users/library/create', params: { painting_ids: [1, 2] }
          user.reload
          expect(user.library.painting_ids).to eq([1, 2])
        end
      end

      context 'when an integer is passed as parameter' do
        it 'creates a library with a single painting_id' do
          post '/api/v1/users/library/create', params: { painting_ids: 1 }
          user.reload
          expect(user.library.painting_ids).to eq([1])
        end
      end

      context 'when painting_id does not exist' do
        it 'throws exception' do
          post '/api/v1/users/library/create', params: { painting_ids: [1, 2, 3] }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not create library' do
          post '/api/v1/users/library/create', params: { painting_ids: [1, 2, 3] }
          expect(user.library).to be_nil
        end
      end
    end

    describe 'DELETE /destroy' do
      context 'when user has a library' do
        before do
          create(:library, user_id: user.id)
        end

        it 'returns successful response' do
          delete '/api/v1/users/library/destroy'
          expect(response).to have_http_status(:ok)
        end

        it 'deletes library' do
          delete '/api/v1/users/library/destroy'
          user.reload
          expect(user.library).to be_nil
        end
      end

      context 'when user does not have a library' do
        it 'throws exception response' do
          delete '/api/v1/users/library/destroy'
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PATCH /add_paintings' do
      before do
        create(:library, user_id: user.id, painting_ids: 1)
      end

      context 'when user does not have a library' do
        before do
          user.library.destroy
          user.reload
        end

        it 'throws exception response' do
          patch '/api/v1/users/library/add_paintings'
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when no parameter is passed' do
        it 'keeps latest value' do
          patch '/api/v1/users/library/add_paintings'
          expect(user.library.painting_ids).to eq([1])
        end

        it 'does not throws an exception message' do
          patch '/api/v1/users/library/add_paintings'
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when a new painting is added' do
        it 'keeps latest values and add the new one' do
          patch '/api/v1/users/library/add_paintings', params: { painting_ids: 2 }
          expect(user.library.painting_ids).to eq([1, 2])
        end
      end

      context 'when adding a non existing painting' do
        it 'throws exception response' do
          patch '/api/v1/users/library/add_paintings', params: { painting_ids: 3 }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PATCH /remove_paintings' do
      before do
        create(:library, user_id: user.id, painting_ids: [1, 2])
        user.reload
      end

      context 'when user does not have a library' do
        before do
          user.library.destroy
          user.reload
        end

        it 'throws exception response' do
          patch '/api/v1/users/library/remove_paintings'
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when all paintings are deleted' do
        let(:all_painting_ids) { user.library.painting_ids }

        it 'returns successful response' do
          patch '/api/v1/users/library/remove_paintings', params: { painting_ids: all_painting_ids }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when a painting_id that is not in library is passed' do
        it 'still returns a successful message' do
          patch '/api/v1/users/library/remove_paintings', params: { painting_ids: [1, 2, 3] }
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe 'GET /show' do
      context 'when user does not have a library' do
        it 'returns not found' do
          get '/api/v1/users/library/show'
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when user has a library' do
        before do
          create(:library, user_id: user.id, painting_ids: [1, 2])
        end

        it 'returns successful response' do
          get '/api/v1/users/library/show'
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
