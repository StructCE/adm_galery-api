Rails.application.routes.draw do
  devise_for :users

  namespace 'api' do
    namespace 'v1' do
      scope 'users' do
        post 'create', to: 'users#create'
        get 'show/:id', to: 'users#show'
        get 'index', to: 'users#index'
        delete 'destroy/:id', to: 'users#destroy'
        patch 'update/:id', to: 'users#update'
      end
    end
  end
end
