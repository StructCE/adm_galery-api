require 'rails_helper'

RSpec.describe 'Api::V1::Styles', type: :request do
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
      title: 'Titulo',
      description: 'Muito maneiro!'
    )
  end

  context 'when user is not logged' do
    describe 'GET / (index)' do
      context 'when request is valid' do
        before do
          get '/api/v1/styles/'
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
      before do
        post '/api/v1/styles/create', params: { style: new_style }
      end

      it 'has Unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'GET /:id (show)' do
      context 'when request is valid' do
        before do
          get "/api/v1/styles/#{style.id}"
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
      before do
        post "/api/v1/styles/#{style.id}/update", params: { style: new_style }
      end

      it 'has Unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE /:id/destroy' do
      before do
        delete "/api/v1/styles/#{style.id}/destroy"
      end

      it 'has Unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end


  context 'when user is logged but is not an administrator' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    describe 'POST /create' do
      before do
        post '/api/v1/styles/create', params: { style: new_style }
      end

      it 'has Forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'POST /:id/update' do
      before do
        post "/api/v1/styles/#{style.id}/update", params: { style: new_style }
      end

      it 'has Forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'DELETE /:id/destroy' do
      before do
        delete "/api/v1/styles/#{style.id}/destroy"
      end

      it 'has Forbidden status' do
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
      context 'when request is valid' do
        before do
          post '/api/v1/styles/create', params: { style: new_style }
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
          post '/api/v1/styles/create', params: { style: bad_style }
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    describe 'POST /:id/update' do
      context 'when request is valid' do
        before do
          post "/api/v1/styles/#{style.id}/update", params: { style: new_style }
        end

        it 'has OK status' do
          expect(response).to have_http_status(:ok)
        end

        it 'changes title to Name' do
          expect { style.reload }.to change(style, :title).to('Nome')
        end

        it 'responds with a json' do
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end

      context 'when request has bad params' do
        it 'has Bad Request status' do
          post "/api/v1/styles/#{style.id}/update", params: { style: bad_style }
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    describe 'DELETE /:id/destroy' do
      context 'when request is valid' do
        before do
          delete "/api/v1/styles/#{style.id}/destroy"
        end

        it 'has No Content status' do
          expect(response).to have_http_status(:no_content)
        end

        it 'raises excpetion when searching for deleted register' do
          expect { style.reload }.to raise_exception(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
