class Api::V1::RecipesController < ApplicationController
  def index
    @recipes = Recipe.ordered_by_recent_favorites_and_others
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  private

  def user_params
    params.require(:recipe).permit(:id)
  end
end
