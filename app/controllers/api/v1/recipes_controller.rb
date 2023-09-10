class Api::V1::RecipesController < Api::V1::ApplicationBaseController
  # NOTE: 話題のレシピ一覧
  def index
    @recipes = Recipe.published.ordered_by_recent_favorites_and_others
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  # NOTE: 人気レシピ一覧
  def user_popular_recipes
    @user_popular_recipes = Recipe.published.popular_recipes_by_user(params[:id]) # params[:id] -> user_id
    # TODO: ログイン機能が実装されたら、current_userとrecipeのuser_idが同じ場合は以下のようにする
    # @user_popular_recipes = Recipe.without_draft.popular_recipes_by_user(params[:id])
  end

  # NOTE: 新着レシピ一覧
  def user_new_arrival_recipes
    @user_new_arrival_recipes = Recipe.published.new_arrival_recipes_by_user(params[:id]) # params[:id] -> user_id
    # TODO: ログイン機能が実装されたら、current_userとrecipeのuser_idが同じ場合は以下のようにする
    # @user_new_arrival_recipes = Recipe.without_draft.new_arrival_recipes_by_user(params[:id])
  end

  private

  def recipe_params
    params.require(:recipe).permit(:id)
  end
end
