require 'rails_helper'

RSpec.describe 'Api::V1::Paintings', type: :request do
  let(:artista) { create(:artist) }
  let(:estilo) { create(:style) }

  context 'when user is not logged' do
    describe 'GET /index' do
      it 'renders all the paintings' do
        get '/api/v1/paintings/index'
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST /create' do
      let(:pintura) do
        { name: 'Pintura', year: '1000 D.C.', artist_id: artista.id,
          style_id: estilo.id, description: 'Descriçãozinha', currentplace: 'Museu' }
      end

      it 'returns an unauthorized status' do
        post '/api/v1/paintings/create', params: { painting: pintura }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'GET /show' do
      context 'with existing painting' do
        it 'returns an ok status' do
          pintura = create(:painting, artist_id: artista.id, style_id: estilo.id)
          get "/api/v1/paintings/show/#{pintura.id}"
          expect(response).to have_http_status(:ok)
        end
      end

      context 'without existing painting' do
        it 'throws not found response' do
          Painting.destroy_all
          get '/api/v1/paintings/show/1'
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'PUT /update' do
      let(:pintura) { create(:painting, artist_id: artista.id, style_id: estilo.id) }

      atualizado = { name: 'O Grito' }

      it 'returns an unauthorized status' do
        put "/api/v1/paintings/update/#{pintura.id}", params: { painting: atualizado }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE /destroy' do
      let(:pintura) { create(:painting, artist_id: artista.id, style_id: estilo.id) }

      it 'returns an unauthorized status' do
        delete "/api/v1/paintings/destroy/#{pintura.id}"
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
      let(:pintura) do
        { name: 'Pintura', year: '1000 D.C.', artist_id: artista.id,
          style_id: estilo.id, description: 'Descriçãozinha', currentplace: 'Museu' }
      end

      it 'returns a forbidden status' do
        post '/api/v1/paintings/create', params: { painting: pintura }
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'PUT /update' do
      let(:pintura) { create(:painting, artist_id: artista.id, style_id: estilo.id) }

      atualizado = { name: 'O Grito' }

      it 'returns a forbidden status' do
        put "/api/v1/paintings/update/#{pintura.id}", params: { painting: atualizado }
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'DELETE /destroy' do
      let(:pintura) { create(:painting, artist_id: artista.id, style_id: estilo.id) }

      it 'returns a forbidden status' do
        delete "/api/v1/paintings/destroy/#{pintura.id}"
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  context 'when admin is logged' do
    let(:admin) { create(:admin) }

    before do
      sign_in admin
    end

    describe 'POST /create' do
      let(:pintura) do
        { name: 'Pintura', year: '1000 D.C.', artist_id: artista.id,
          style_id: estilo.id, description: 'Descriçãozinha', currentplace: 'Museu' }
      end

      context 'with valid params' do
        it 'returns created status' do
          post '/api/v1/paintings/create', params: { painting: pintura }
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid params' do
        it 'throws unprocessable entity response' do
          pintura = { name: '' }
          post '/api/v1/paintings/create', params: { painting: pintura }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PUT /update' do
      let(:pintura) { create(:painting, artist_id: artista.id, style_id: estilo.id) }

      atualizado = { name: 'O Grito' }

      context 'when painting exists' do
        it 'updates painting' do
          put "/api/v1/paintings/update/#{pintura.id}", params: { painting: atualizado }
          pintura.reload
          expect(pintura.name).to eq(atualizado[:name])
        end

        it 'returns an ok status' do
          put "/api/v1/paintings/update/#{pintura.id}", params: { painting: atualizado }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when painting does not exist' do
        it 'does not update painting' do
          put '/api/v1/paintings/update/2', params: { painting: atualizado }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE /destroy' do
      let(:pintura) { create(:painting, artist_id: artista.id, style_id: estilo.id) }

      context 'when painting exists' do
        it 'deletes painting' do
          delete "/api/v1/paintings/destroy/#{pintura.id}"
          expect(Painting.find_by(id: pintura.id)).to be_nil
        end

        it 'returns a no content successful response' do
          delete "/api/v1/paintings/destroy/#{pintura.id}"
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'when painting does not exist' do
        it 'throws a not found status' do
          pintura.destroy!
          delete "/api/v1/paintings/destroy/#{pintura.id}"
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
