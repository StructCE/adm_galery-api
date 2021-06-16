Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace 'api' do
    namespace 'v1' do
      scope 'artists' do
        post 'create', to: 'artists#create'
        get 'index', to: 'artists#index'
        get 'show/:id', to: 'artists#show'
        delete 'destroy/:id', to: 'artists#destroy'
        put 'update/:id', to: 'artists#update'
      end
    end
  end
end
