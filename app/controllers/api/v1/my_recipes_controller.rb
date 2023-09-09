class Api::V1::MyRecipesController < Api::V1::ApplicationBaseController
  def show
    @recipe = Recipe.find(params[:id])
    # TODO: recipe.userとログインユーザーが同じかどうかをチェックする
    #       recipeのis_publicがfalse かつ recipe.userとログインユーザーが異なる場合、403 Forbiddenの例外を出す
    #       https://github.com/qin-team-recipe/01-backend/issues/133のIssueで対応する
  end
end
