module Api
  module V1
    class RecipesController < ApplicationController
      def index
        recipes = Recipe.ordered_by_recent_favorites_and_others
        render json: recipes
      end
    end
  end
end
