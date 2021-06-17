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
      post 'logout', to: 'users#logout'


      scope 'styles' do
        get '', to: 'styles#index'
        post 'create', to: 'styles#create'
        get ':id', to: 'styles#show'
        post ':id/update', to: 'styles#update'
        delete ':id/destroy', to: 'styles#destroy'
      end

    end
  end
end
