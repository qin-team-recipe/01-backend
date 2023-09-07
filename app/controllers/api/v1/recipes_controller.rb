class Api::V1::RecipesController < Api::V1::ApplicationBaseController
  def index
    @recipes = Recipe.ordered_by_recent_favorites_and_others
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def user_popular_recipes
    @user_popular_recipes = Recipe.popular_recipes_by_user(params[:id]) # params[:id] -> user_id
  end

  private

  def recipe_params
    params.require(:recipe).permit(:id)
  end
end
