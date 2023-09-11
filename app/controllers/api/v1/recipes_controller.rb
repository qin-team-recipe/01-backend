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

  def user_new_arrival_recipes
    @user_new_arrival_recipes = Recipe.new_arrival_recipes_by_user(params[:id])
  end

  def search
    keyword = params[:keyword]
    page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @recipes = Recipe.search_by_name(keyword).paginate(page)
  end

  private

  def recipe_params
    params.require(:recipe).permit(:id)
  end
end
