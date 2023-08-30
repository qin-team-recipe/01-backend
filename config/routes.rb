Rails.application.routes.draw do
  namespace 'api', defaults: { format: 'json' } do
    namespace 'v1' do
      resources :recipes

      resources :users do
        resources :carts, only: %i[index], controller: 'cart_lists'
      end
    end
  end
end
