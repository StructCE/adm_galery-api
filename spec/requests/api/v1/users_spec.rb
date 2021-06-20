require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  before do
    User.delete_all
  end

  let(:user) { create(:user) }
  let(:private_user) { create(:user, email: 'teste@private.com', confidential: true) }
  let(:public_user) { create(:user, email: 'teste@public.com', confidential: false) }

  describe 'POST /login' do
    context 'when user logs in correctly' do
      it 'returns a successful response' do
        post '/api/v1/login', params: { email: 'teste@teste.com', password: 'TesteSenha' }
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
        sign_in user
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
        sign_in user
      end

      it 'shows index' do
        get '/api/v1/users/index'
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /show' do
    context 'when user is not logged' do
      it 'does not show user' do
        get "/api/v1/users/show/#{user.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is logged and wants to see other user profiles' do
      before do
        sign_in user
      end

      it 'does not show private profiles' do
        get "/api/v1/users/show/#{private_user.id}"
        expect(response).to have_http_status(:forbidden)
      end

      it 'shows public profiles' do
        get "/api/v1/users/show/#{public_user.id}"
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is logged and profile does not exist' do
      before do
        sign_in user
        User.find(public_user.id).destroy
      end

      it 'returns not found message' do
        get "/api/v1/users/show/#{public_user.id}"
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is logged and wants to see his own profile' do
      before do
        sign_in private_user
      end

      it 'shows his private profile' do
        get "/api/v1/users/show/#{private_user.id}"
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST /create' do
    let(:user_params) do
      {
        name: 'Teste da Silva',
        bio: 'Testing create user method',
        email: 'teste@signup.com',
        password: 'TesteSenha',
        password_confirmation: 'TesteSenha',
        confidential: true
      }
    end

    context 'when user sign up with valid params' do
      it 'returns a success message when all fields are provided and correct' do
        post '/api/v1/users/create', params: { user: user_params }
        expect(response).to have_http_status(:created)
      end

      it 'finds new user' do
        post '/api/v1/users/create', params: { user: user_params }
        user = User.find_by(email: user_params[:email])
        expect(user).not_to be_nil
      end
    end

    context 'when user sign up with invalid params' do
      it 'returns a failure message when any field is incorrect or missing' do
        user_params[:email] = 'test'
        post '/api/v1/users/create', params: { user: user_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not find new user' do
        user_params[:email] = 'test'
        post '/api/v1/users/create', params: { user: user_params }
        user = User.find_by(email: user_params[:email])
        expect(user).to be_nil
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when user is not logged' do
      it 'throws unauthorized message' do
        delete '/api/v1/users/destroy'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is logged' do
      before do
        sign_in user
      end

      it 'returns success message' do
        delete '/api/v1/users/destroy'
        expect(response).to have_http_status(:ok)
      end

      it 'cannot find user anymore' do
        delete '/api/v1/users/destroy'
        usuario = User.find_by(id: user.id)
        expect(usuario).to be_nil
      end
    end
  end

  describe 'PATCH /update' do
    let(:user_params) do
      {
        name: 'Teste da Silva',
        bio: 'Testing create user method',
        email: 'teste@signup.com',
        password: 'TesteSenha',
        password_confirmation: 'TesteSenha',
        confidential: true
      }
    end

    context 'when user is not logged' do
      it 'throws unauthorized message' do
        patch '/api/v1/users/update', params: { user: user_params }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is logged' do
      before do
        sign_in user
      end

      it 'returns a successful response' do
        patch '/api/v1/users/update', params: { user: user_params }
        expect(response).to have_http_status(:ok)
      end

      it 'updates user info' do
        patch '/api/v1/users/update', params: { user: user_params }
        usuario = User.find(user.id)
        expect(usuario.name).to eq(user_params[:name])
      end

      it 'throws error when some field is incorrect' do
        user_params[:email] = 'test'
        patch '/api/v1/users/update', params: { user: user_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not update info when some field is incorrect' do
        user_params[:email] = 'test'
        patch '/api/v1/users/update', params: { user: user_params }
        usuario = User.find(user.id)
        expect(usuario.email).not_to eq(user_params[:email])
      end
    end
  end
end
