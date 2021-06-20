require 'rails_helper'

RSpec.describe 'Api::V1::Paintings', type: :request do
  let(:artista) { create(:artist) }
  let(:estilo) { create(:style) }

  context 'GET /index' do
    it 'renders all the paintings' do
      get '/api/v1/paintings/index'
      expect(response).to have_http_status(:ok)
    end
  end

  context 'POST /create' do
    let(:pintura) do
      { name: 'Pintura', year: '1000 D.C.', artist_id: artista.id,
        style_id: estilo.id, description: 'Descriçãozinha', currentplace: 'Museu' }
    end

    it 'with valid params' do
      post '/api/v1/paintings/create', params: { painting: pintura }
      expect(response).to have_http_status(:created)
    end

    it 'with invalid params' do
      pintura = { name: '' }
      post '/api/v1/paintings/create', params: { painting: pintura }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'GET /show' do
    it 'with existing painting' do
      pintura = create(:painting, artist_id: artista.id, style_id: estilo.id)
      get "/api/v1/paintings/show/#{pintura.id}"
      expect(response).to have_http_status(:ok)
    end

    it 'without existing painting' do
      get '/api/v1/paintings/show/1'
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'PUT /update' do
    let(:pintura) { create(:painting, artist_id: artista.id, style_id: estilo.id) }

    atualizado = { name: 'O Grito' }

    it 'updates painting' do
      put "/api/v1/paintings/update/#{pintura.id}", params: { painting: atualizado }
      pintura.reload
      expect(response).to have_http_status(:ok)
      expect(pintura.name).to eq(atualizado[:name])
    end

    it 'does not update painting' do
      put '/api/v1/paintings/update/2', params: { painting: atualizado }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'DELETE /destroy' do
    let(:pintura) { create(:painting, artist_id: artista.id, style_id: estilo.id) }

    it 'deletes painting' do
      delete "/api/v1/paintings/destroy/#{pintura.id}"
      expect(response).to have_http_status(:ok)
      expect(Painting.find_by(id: pintura.id)).to be_nil
    end

    it 'with non existing painting' do
      pintura.destroy!
      delete "/api/v1/paintings/destroy/#{pintura.id}"
      expect(response).to have_http_status(:not_found)
    end
  end
end
