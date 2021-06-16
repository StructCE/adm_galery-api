Rails.application.routes.draw do
  devise_for :users, skip: :all

  namespace 'api' do
    namespace 'v1' do
      scope 'users' do
        post 'create', to: 'users#create'
        get 'show/:id', to: 'users#show'
        get 'index', to: 'users#index'
        delete 'destroy', to: 'users#destroy'
        patch 'update', to: 'users#update'
      end

      post 'login', to: 'users#login'
    end
  end
end
