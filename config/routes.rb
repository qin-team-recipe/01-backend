Rails.application.routes.draw do
  namespace 'api', defaults: { format: 'json' } do
    namespace 'v1' do
      resources :recipes, only: %i[index show] do
        collection do
          get :search
        end
      end

      resources :users do
        resources :cart_lists, only: %i[index]

        member do
          get :popular_recipes, to: 'recipes#user_popular_recipes'
          get :new_arrival_recipes, to: 'recipes#user_new_arrival_recipes'
        end
      end

      resources :chefs, only: %i[index show]
    end
  end
end
