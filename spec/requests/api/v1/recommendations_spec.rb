require 'rails_helper'

RSpec.describe "Api::V1::Recommendations", type: :request do
  # Valid style params
  let(:new_recommendation) do
    { title: 'Nome', description: 'Muito maneiro!' }
  end

  # Bad style params
  let(:bad_recommendation) do
    { title: '', description: 'oi' }
  end

  # Base style created
  let(:recommendation) do
    Recommendation.create!(
      title: 'Titulo',
      description: 'Muito maneiro!'
    )
  end

  describe 'GET / (index)' do
    context 'when request is valid' do
      before do
        get '/api/v1/recommendations/'
      end

      it 'has OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with a json' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'POST /create' do
    context 'when request is valid' do
      before do
        post '/api/v1/recommendations/create', params: { recommendation: new_recommendation }
      end

      it 'has Created status' do
        expect(response).to have_http_status(:created)
      end

      it 'responds with a json' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'when request has invalid params' do
      it 'has Bad Request status' do
        post '/api/v1/recommendations/create', params: { recommendation: bad_recommendation }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET /:id (show)' do
    context 'when request is valid' do
      before do
        get "/api/v1/recommendations/#{recommendation.id}"
      end

      it 'has OK response' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with a json' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'POST /:id/update' do
    context 'when request is valid' do
      before do
        post "/api/v1/recommendations/#{recommendation.id}/update", params: { recommendation: new_recommendation }
      end

      it 'has OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'changes title to Nome' do
        expect { recommendation.reload }.to change(recommendation, :title).to('Nome')
      end

      it 'responds with a json' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'when request has bad params' do
      it 'has Bad Request status' do
        post "/api/v1/recommendations/#{recommendation.id}/update", params: { recommendation: bad_recommendation }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE /:id/destroy' do
    context 'when request is valid' do
      before do
        delete "/api/v1/recommendations/#{recommendation.id}/destroy"
      end

      it 'has No Content status' do
        expect(response).to have_http_status(:no_content)
      end

      it 'raises excpetion when searching for deleted register' do
        expect { recommendation.reload }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
