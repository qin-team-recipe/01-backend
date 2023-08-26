class Api::V1::RecipesController < ApplicationController
  def index
    @recipes = Recipe.ordered_by_recent_favorites_and_others
  end
end
