Rails.application.routes.draw do
  namespace 'api', defaults: { format: 'json' } do
    namespace 'v1' do
      resources :recipes, only: %i[index show]

      resources :users do
        resources :cart_lists, only: %i[index]
      end
    end
  end
end
