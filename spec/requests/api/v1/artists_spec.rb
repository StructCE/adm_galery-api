require 'rails_helper'

RSpec.describe "Api::V1::Artists", type: :request do
  context "GET /index" do
    it 'should render all the artists' do
      get '/api/v1/artists/index'
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /create" do
    let(:artista) do
      { name: 'Artista', biography: 'Artista de teste', birthdate: '2000-07-04', deathdate: '2020-01-26', birthplace: 'Algum lugar' }
    end

    it 'with valid params' do
      post '/api/v1/artists/create', params: { artist: artista }
      expect(response).to have_http_status(:created)
    end

    it 'with invalid params' do
      artista = { name: '' }
      post '/api/v1/artists/create', params: { artist: artista }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context "GET /show" do
    it 'with existing artist' do
      artista = create(:artist)
      get "/api/v1/artists/show/#{artista.id}"
      expect(response).to have_http_status(:ok)
    end

    it 'without existing artist' do
      get "/api/v1/artists/show/1"
      expect(response).to have_http_status(:not_found)
    end
  end

  context "PUT /update" do
    let(:artista) { create(:artist) }
    atualizado = { name: 'Arlindo' }

    it 'should update artist' do
      put "/api/v1/artists/update/#{artista.id}", params: { artist: atualizado }
      artista.reload
      expect(response).to have_http_status(:ok)
      expect(artista.name).to eq(atualizado[:name])
    end

    it 'should not update artist' do
      put "/api/v1/artists/update/2", params: { artist: atualizado }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context "DELETE /destroy" do
    let(:artista) { create(:artist) }

    it 'should delete artist' do
      delete "/api/v1/artists/destroy/#{artista.id}"
      expect(response).to have_http_status(:ok)
      expect(Artist.find_by(id: artista.id)).to be_nil
    end

    it 'with non existing artist' do
      artista.destroy!
      delete "/api/v1/artists/destroy/#{artista.id}"
      expect(response).to have_http_status(:not_found)
    end
  end
end
