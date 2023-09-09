require 'rails_helper'

RSpec.describe 'MyRecipes' do
  describe 'GET /recipes/:id' do
    context 'レシピのレコードがあるとき' do
      let!(:recipe) { create(:recipe, :with_user) }
      let!(:step) { create(:step, recipe:) }
      let!(:material) { create(:material, recipe:) }
      let!(:recipe_external_link) { create(:recipe_external_link, :with_url_type, recipe:) }

      it '200を返却すること' do
        get my_recipes_show_api_v1_user_path(recipe)
        expect(response).to have_http_status(:ok)
      end

      it 'recipeのレコードを返却すること' do
        get my_recipes_show_api_v1_user_path(recipe)

        expect(response.parsed_body).to include({
                                                  'id' => recipe.id,
                                                  'name' => recipe.name,
                                                  'description' => recipe.description,
                                                  'favorite_count' => recipe.favoriters_count,
                                                  'thumbnail' => recipe.thumbnail,
                                                  'serving_size' => recipe.serving_size,
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
  end
end
