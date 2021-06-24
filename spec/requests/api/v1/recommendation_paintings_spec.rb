require 'rails_helper'

RSpec.describe 'Api::V1::Recommendations', type: :request do
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

  # Base reccomendation created
  let(:recommendation) do
    Recommendation.create!(
      title: 'Titulo',
      description: 'Muito maneiro!'
    )
  end

  # Recommendation_paintings join table requests

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
        post "/api/v1/recommendations/#{recommendation.id}/paintings/add",
             params: { painting_id: painting.id.to_s }
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
        post "/api/v1/recommendations/#{recommendation.id}/paintings/add",
             params: { painting_id: painting.id.to_s }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE /paintings/remove' do
    context 'when request is valid' do
      before do
        delete "/api/v1/recommendations/#{recommendation.id}/paintings/remove",
               params: { painting_id: painting.id.to_s }
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
