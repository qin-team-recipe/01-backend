class Api::V1::MyRecipesController < Api::V1::ApplicationBaseController
  before_action :set_recipe
  before_action :check_request_ids_params

  def show
    # TODO: recipe.userとログインユーザーが同じかどうかをチェックする
    #       recipeのis_publicがfalse かつ recipe.userとログインユーザーが異なる場合、403 Forbiddenの例外を出す
    #       https://github.com/qin-team-recipe/01-backend/issues/133のIssueで対応する
  end

  def edit
    # TODO: recipe.userとログインユーザーが同じかどうかをチェックする
    #       recipeのis_publicがfalse かつ recipe.userとログインユーザーが異なる場合、403 Forbiddenの例外を出す
    #       https://github.com/qin-team-recipe/01-backend/issues/133のIssueで対応する
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def check_request_ids_params
    raise ActionController::BadRequest unless params[:user_id].to_i == @recipe.user_id
  end
end
