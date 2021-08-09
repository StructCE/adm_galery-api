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
        post 'edit_image/:id', to: 'users#edit_image'
      end

      scope 'library' do
        post 'create', to: 'libraries#create'
        delete 'destroy', to: 'libraries#destroy'
        patch 'add_paintings', to: 'libraries#add_paintings'
        patch 'remove_paintings', to: 'libraries#remove_paintings'
        get 'show', to: 'libraries#show'
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
      
      scope 'artists' do
        post 'create', to: 'artists#create'
        get 'index', to: 'artists#index'
        get 'show/:id', to: 'artists#show'
        delete 'destroy/:id', to: 'artists#destroy'
        put 'update/:id', to: 'artists#update'
        post 'edit_picture/:id', to: 'artists#edit_picture'
      end

      scope 'paintings' do
        post 'create', to: 'paintings#create'
        get 'index', to: 'paintings#index'
        get 'show/:id', to: 'paintings#show'
        delete 'destroy/:id', to: 'paintings#destroy'
        put 'update/:id', to: 'paintings#update'
        post 'edit_image/:id', to: 'paintings#edit_image'
      end

      scope 'recommendations' do
        get '', to: 'recommendations#index'
        post 'create', to: 'recommendations#create'
        get ':id', to: 'recommendations#show'
        patch ':id/update', to: 'recommendations#update'
        delete ':id/destroy', to: 'recommendations#destroy'
        get ':id/paintings', to: 'recommendations#all_paintings'
        post ':id/paintings/add', to: 'recommendations#add_painting'
        delete ':id/paintings/remove', to: 'recommendations#remove_painting'
      end
    end
  end
end
