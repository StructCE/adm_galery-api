Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
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
