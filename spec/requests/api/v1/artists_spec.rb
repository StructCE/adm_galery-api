require 'rails_helper'

RSpec.describe 'Api::V1::Artists', type: :request do

  context 'when user is not logged' do
    describe 'GET /index' do
      it 'renders all the artists' do
        get '/api/v1/artists/index'
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST /create' do
      let(:artista) do
        { name: 'Artista', biography: 'Artista de teste', birthdate: '2000-07-04',
          deathdate: '2020-01-26', birthplace: 'Algum lugar' }
      end

      it 'returns unauthorized response' do
        post '/api/v1/artists/create', params: { artist: artista }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'GET /show' do
      context 'with existing artist' do
        it 'returns an ok response' do
          artista = create(:artist)
          get "/api/v1/artists/show/#{artista.id}"
          expect(response).to have_http_status(:ok)
        end
      end

      context 'without existing artist' do
        it 'returns a not found response' do
          Artist.destroy_all
          get '/api/v1/artists/show/1'
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'PUT /update' do
      let(:artista) { create(:artist) }

      atualizado = { name: 'Arlindo' }

      it 'returns unauthorized response' do
        put "/api/v1/artists/update/#{artista.id}", params: { artist: atualizado }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE /destroy' do
      let(:artista) { create(:artist) }

      it 'returns an unauthorized response' do
        delete "/api/v1/artists/destroy/#{artista.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end


  context 'when user is logged but is not admin' do

    let(:user) { create(:user) }

    before do
      sign_in user
    end

    describe 'POST /create' do
      let(:artista) do
        { name: 'Artista', biography: 'Artista de teste', birthdate: '2000-07-04',
          deathdate: '2020-01-26', birthplace: 'Algum lugar' }
      end

      it 'returns unauthorized response' do
        post '/api/v1/artists/create', params: { artist: artista }
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'PUT /update' do
      let(:artista) { create(:artist) }

      atualizado = { name: 'Arlindo' }

      it 'returns unauthorized response' do
        put "/api/v1/artists/update/#{artista.id}", params: { artist: atualizado }
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'DELETE /destroy' do
      let(:artista) { create(:artist) }

      it 'returns an unauthorized response' do
        delete "/api/v1/artists/destroy/#{artista.id}"
        expect(response).to have_http_status(:forbidden)
      end
    end
  end


  context 'when admin is logged' do
    let(:admin) { create(:admin) }

    before do
      sign_in admin
    end

    describe 'GET /index' do
      it 'renders all the artists' do
        get '/api/v1/artists/index'
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST /create' do
      let(:artista) do
        { name: 'Artista', biography: 'Artista de teste', birthdate: '2000-07-04',
          deathdate: '2020-01-26', birthplace: 'Algum lugar' }
      end

      context 'with valid params' do
        it 'returns a created status' do
          post '/api/v1/artists/create', params: { artist: artista }
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid params' do
        it 'throws exception response' do
          artista = { name: '' }
          post '/api/v1/artists/create', params: { artist: artista }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'GET /show' do
      context 'with existing artist' do
        it 'returns an ok response' do
          artista = create(:artist)
          get "/api/v1/artists/show/#{artista.id}"
          expect(response).to have_http_status(:ok)
        end
      end

      context 'without existing artist' do
        it 'returns a not found response' do
          Artist.destroy_all
          get '/api/v1/artists/show/1'
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'PUT /update' do
      let(:artista) { create(:artist) }

      atualizado = { name: 'Arlindo' }
      context 'with valid params' do
        it 'updates artist' do
          put "/api/v1/artists/update/#{artista.id}", params: { artist: atualizado }
          artista.reload
          expect(artista.name).to eq(atualizado[:name])
        end

        it 'returns ok response' do
          put "/api/v1/artists/update/#{artista.id}", params: { artist: atualizado }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when artist does not exist' do
        it 'throws exception response' do
          put '/api/v1/artists/update/2', params: { artist: atualizado }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE /destroy' do
      let(:artista) { create(:artist) }

      context 'with existing artist' do
        it 'deletes artist' do
          delete "/api/v1/artists/destroy/#{artista.id}"
          expect(Artist.find_by(id: artista.id)).to be_nil
        end

        it 'returns ok response' do
          delete "/api/v1/artists/destroy/#{artista.id}"
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'without existing artist' do
        it 'with non existing artist' do
          artista.destroy!
          delete "/api/v1/artists/destroy/#{artista.id}"
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
