require 'rails_helper'

RSpec.describe 'Api::V1::Recommendations', type: :request do
  # Valid reccomendation params
  let(:new_recommendation) do
    { title: 'Nome', description: 'Muito maneiro!' }
  end

  # Bad reccomendation params
  let(:bad_recommendation) do
    { title: '', description: 'oi' }
  end

  # Base reccomendation created
  let(:recommendation) do
    Recommendation.create!(
      title: 'Titulo',
      description: 'Muito maneiro!'
    )
  end

  # Recommendation base request
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
        post "/api/v1/recommendations/#{recommendation.id}/update",
             params: { recommendation: new_recommendation }
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
        post "/api/v1/recommendations/#{recommendation.id}/update",
             params: { recommendation: bad_recommendation }
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

  # Recommendation_paintings join table requests

  # Base reccomendation created
  let(:alt_recommendation) do
    Recommendation.create!(
      title: 'Outro',
      description: 'Muito maneiro!'
    )
  end

  # Base style created
  let(:style) do
    Style.create!(
      title: 'Titulo',
      description: 'Muito maneiro!'
    )
  end

  # Base artist created
  let(:artist) do
    Artist.create!(
      name: 'Nome',
      biography: 'Artista renascentista',
      birthdate: '2021-06-15',
      deathdate: '2021-06-16',
      birthplace: 'Itália'
    )
  end

  # Base painting created
  let(:painting) do
    Painting.create!(
      name: 'Nome',
      year: '1503-1506',
      artist: artist,
      style: style,
      description: 'Mona Lisa, também conhecida como A Gioconda',
      currentplace: 'Museu do Louvre'
    )
  end

  # Base join created
  let(:join) do
    RecommendationPainting.create!(
      recommendation: recommendation,
      painting: painting
    )
  end

  describe 'GET /paintings/ (index)' do
    context 'when request is valid' do
      before do
        get "/api/v1/recommendations/#{recommendation.id}/paintings"
      end

      it 'has OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with a json' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'POST /paintings/add/' do
    context 'when request is valid' do
      before do
        post "/api/v1/recommendations/#{alt_recommendation.id}/paintings/add", params: { painting_id: "#{painting.id}" }
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
        RecommendationPainting.create!(recommendation: recommendation, painting: painting)
        post "/api/v1/recommendations/#{recommendation.id}/paintings/add", params: { painting_id: "#{painting.id}" }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE /paintings/remove' do
    context 'when request is valid' do
      before do
        delete "/api/v1/recommendations/#{recommendation.id}/paintings/remove", params: { painting_id: "#{painting.id}" }
      end

      it 'has No Content status' do
        expect(response).to have_http_status(:no_content)
      end

      it 'raises excpetion when searching for deleted register' do
        expect(recommendation.paintings).to be_empty
      end
    end
  end
end
