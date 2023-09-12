require 'rails_helper'

RSpec.describe 'MyRecipes' do
  describe 'GET /users/:user_id/my_recipes/:id' do
    context 'レシピのレコードがあるとき' do
      let!(:recipe) { create(:recipe, :with_user) }
      let!(:step) { create(:step, recipe:) }
      let!(:material) { create(:material, recipe:) }
      let!(:recipe_external_link) { create(:recipe_external_link, :with_url_type, recipe:) }

      it '200を返却すること' do
        get api_v1_user_my_recipe_path(recipe.user, recipe)
        expect(response).to have_http_status(:ok)
      end

      it 'recipeのレコードを返却すること' do
        get api_v1_user_my_recipe_path(recipe.user, recipe)

        expect(response.parsed_body).to include({
                                                  'id' => recipe.id,
                                                  'name' => recipe.name,
                                                  'description' => recipe.description,
                                                  'favorite_count' => recipe.favoriters_count,
                                                  'thumbnail' => recipe.thumbnail,
                                                  'serving_size' => recipe.serving_size,
                                                  'is_favorite' => false, # TODO: ログイン機能ができたら実装する
                                                  'is_public' => recipe.is_public,
                                                  'is_draft' => recipe.is_draft,
                                                  'author_type' => recipe.author_type,
                                                  'steps' => [
                                                    'description' => step.description,
                                                    'position' => step.position
                                                  ],
                                                  'materials' => [
                                                    'name' => material.name,
                                                    'position' => material.position
                                                  ],
                                                  'external_links' => [
                                                    'type' => recipe_external_link.url_type,
                                                    'url' => recipe_external_link.url
                                                  ],
                                                  'created_at' => recipe.created_at.iso8601(3),
                                                  'updated_at' => recipe.updated_at.iso8601(3)
                                                })
      end
    end

    context 'リクエストされたuser_idとrecipe_idに整合性がない場合' do
      let!(:recipe) { create(:recipe, :with_user) }
      let!(:another_user) { create(:user) }

      it '400を返却すること' do
        get api_v1_user_my_recipe_path(another_user, recipe)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET /users/:user_id/my_recipes/:id/edit' do
    context 'レシピのレコードがあるとき' do
      let!(:recipe) { create(:recipe, :with_user) }
      let!(:step) { create(:step, recipe:) }
      let!(:material) { create(:material, recipe:) }
      let!(:recipe_external_link) { create(:recipe_external_link, :with_url_type, recipe:) }

      it '200を返却すること' do
        get edit_api_v1_user_my_recipe_path(recipe.user, recipe)
        expect(response).to have_http_status(:ok)
      end

      it 'recipeのレコードを返却すること' do
        get edit_api_v1_user_my_recipe_path(recipe.user, recipe)

        expect(response.parsed_body).to include({
                                                  'id' => recipe.id,
                                                  'name' => recipe.name,
                                                  'description' => recipe.description,
                                                  'thumbnail' => recipe.thumbnail,
                                                  'is_draft' => recipe.is_draft,
                                                  'is_public' => recipe.is_public,
                                                  'serving_size' => recipe.serving_size,
                                                  'steps' => [
                                                    'description' => step.description,
                                                    'position' => step.position
                                                  ],
                                                  'materials' => [
                                                    'name' => material.name,
                                                    'position' => material.position
                                                  ],
                                                  'external_links' => [
                                                    'type' => recipe_external_link.url_type,
                                                    'url' => recipe_external_link.url
                                                  ],
                                                  'created_at' => recipe.created_at.iso8601(3),
                                                  'updated_at' => recipe.updated_at.iso8601(3)
                                                })
      end
    end

    context 'リクエストされたuser_idとrecipe_idに整合性がない場合' do
      let!(:recipe) { create(:recipe, :with_user) }
      let!(:another_user) { create(:user) }

      it '400を返却すること' do
        get edit_api_v1_user_my_recipe_path(another_user, recipe)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
