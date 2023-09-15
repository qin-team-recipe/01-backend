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
        resources :my_recipes, only: %i[show edit]
        resources :favorite_chefs, only: [:create, :destroy], param: :chef_id

        member do
          get :popular_recipes, to: 'recipes#user_popular_recipes'
          get :new_arrival_recipes, to: 'recipes#user_new_arrival_recipes'
        end
      end

      resources :chefs, only: %i[index show] do
        collection do
          get :search
        end
      end
    end
  end
end
