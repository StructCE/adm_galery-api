require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do

  before do
    User.delete_all
    @user = create(:user)
  end

  def valid_login
    post '/api/v1/login', params: { email: 'teste@teste.com', password: 'TesteSenha' }
  end

  describe 'POST /login' do
    context 'when user logs in correctly' do
      it 'returns a successful response' do
        valid_login
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user miss login params' do
      it 'returns unauthorized when email is wrong' do
        post '/api/v1/login', params: { email: 'teste.com', password: 'TesteSenha' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized when password is wrong' do
        post '/api/v1/login', params: { email: 'teste@teste.com', password: 'Senha' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /logout' do
    context 'when user is not logged' do
      it 'returns bad request' do
        post '/api/v1/logout'
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when user is logged' do
      before do
        sign_in @user
      end
      it 'returns ok' do
        post '/api/v1/logout'
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /index' do
    context 'when user is not logged' do
      it 'does not show index' do
        get '/api/v1/users/index'
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context 'when user is logged' do
      before do
        sign_in @user
      end
      it 'shows index' do
        get '/api/v1/users/index'
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
