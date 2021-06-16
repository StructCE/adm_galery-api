require 'rails_helper'

RSpec.describe "Api::V1::Styles", type: :request do
  # Valid style params
  let(:new_style) do
    { title: 'Nome', description: 'Muito maneiro!' }
  end

  # Bad style params
  let(:bad_style) do
    { title: '', description: 'oi' }
  end

  # Base style created
  let(:style) do
    Style.create!(
      title: "Titulo",
      description: "Muito maneiro!"
    )
  end

  context 'GET / (index)' do
    it 'should render all styles' do
      get '/api/v1/styles/'
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end
  end

  context 'POST /create' do
    it 'is valid' do
      post '/api/v1/styles/create', params: { style: new_style }
      expect(response).to have_http_status(:created)
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end

    it 'without valid params' do
      post '/api/v1/styles/create', params: { style: bad_style }
      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'GET /:id (show)' do
    it 'is valid' do
      get "/api/v1/styles/#{style.id}"
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end
  end

  context 'POST /:id/update' do
    it 'is valid' do
      post "/api/v1/styles/#{style.id}/update", params: { style: new_style }
      expect(response).to have_http_status(:ok)
      expect { style.reload }.to change(style, :title).to('Nome')
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end

    it 'without valid params' do
      post "/api/v1/styles/#{style.id}/update", params: { style: bad_style }
      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'DELETE /:id/destroy' do
    it 'should delete' do
      delete "/api/v1/styles/#{style.id}/destroy"
      expect(response).to have_http_status(:no_content)
      expect{ style.reload }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
