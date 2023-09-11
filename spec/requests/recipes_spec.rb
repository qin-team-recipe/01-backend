require 'rails_helper'

RSpec.describe 'Recipes' do
  describe 'GET /recipes' do
    context 'レシピのレコードがあるとき' do
      let!(:recipe) { create(:recipe, :with_user) }

      it '200を返却すること' do
        get api_v1_recipes_path
        expect(response).to have_http_status(:ok)
      end

      it 'レスポンスの中身は1件のみであること' do
        get api_v1_recipes_path

        expect(response.parsed_body.length).to eq 1
      end

      it 'recipeのレコードを返却すること' do
        get api_v1_recipes_path

        expect(response.parsed_body[0]).to include({
                                                     'id' => recipe.id,
                                                     'name' => recipe.name,
                                                     'description' => recipe.description,
                                                     'favorite_count' => recipe.favoriters_count,
                                                     'thumbnail' => recipe.thumbnail,
                                                     'chef_name' => recipe.user.name,
                                                     'created_at' => recipe.created_at.iso8601(3),
                                                     'updated_at' => recipe.updated_at.iso8601(3)
                                                   })
      end
    end
  end

  describe 'GET /recipes/:id' do
    context 'レシピのレコードがあるとき' do
      let!(:recipe) { create(:recipe, :with_user) }
      let!(:step) { create(:step, recipe:) }
      let!(:material) { create(:material, recipe:) }
      let!(:recipe_external_link) { create(:recipe_external_link, :with_url_type, recipe:) }

      it '200を返却すること' do
        get api_v1_recipe_path(recipe)
        expect(response).to have_http_status(:ok)
      end

      it 'recipeのレコードを返却すること' do
        get api_v1_recipe_path(recipe)

        expect(response.parsed_body).to include({
                                                  'id' => recipe.id,
                                                  'name' => recipe.name,
                                                  'description' => recipe.description,
                                                  'favorite_count' => recipe.favoriters_count,
                                                  'thumbnail' => recipe.thumbnail,
                                                  'chef_name' => recipe.user.name,
                                                  'serving_size' => recipe.serving_size,
                                                  'is_favorite' => false, # TODO: ログイン機能ができたら実装する
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

  describe 'GET /users/:user_id/popular_recipes' do
    let(:user) { create(:user) }
    let!(:recipe) { create(:recipe, user:) }

    context 'レシピのレコードがあるとき' do
      it '200を返却すること' do
        get popular_recipes_api_v1_user_path(user)
        expect(response).to have_http_status(:ok)
      end

      it 'レスポンスの中身は1件のみであること' do
        get popular_recipes_api_v1_user_path(user)

        expect(response.parsed_body.length).to eq 1
      end

      it 'recipeのレコードを返却すること' do
        get popular_recipes_api_v1_user_path(user)

        expect(response.parsed_body[0]).to include({
                                                     'id' => recipe.id,
                                                     'name' => recipe.name,
                                                     'description' => recipe.description,
                                                     'favorite_count' => recipe.favoriters_count,
                                                     'thumbnail' => recipe.thumbnail,
                                                     'chef_name' => recipe.user.name,
                                                     'created_at' => recipe.created_at.iso8601(3),
                                                     'updated_at' => recipe.updated_at.iso8601(3)
                                                   })
      end
    end
  end

  # TODO: controllerの修正に合わせてテストを修正する
  describe 'GET /api/v1/recipes/search' do
    let(:user) { create(:user) }

    context '返却値の構造を確認' do
      let!(:recipe) { create(:recipe, user:, name: 'パスタグラタン') }

      before do
        get '/api/v1/recipes/search', params: { keyword: 'グラタン', page: 1 }
      end

      it 'recipeのレコードを返却すること' do
        expect(response.parsed_body[0]).to include({
                                                     'id' => recipe.id,
                                                     'name' => recipe.name,
                                                     'description' => recipe.description,
                                                     'favorite_count' => recipe.favoriters_count,
                                                     'thumbnail' => recipe.thumbnail,
                                                     'chef_name' => recipe.user.name,
                                                     'created_at' => recipe.created_at.iso8601(3),
                                                     'updated_at' => recipe.updated_at.iso8601(3)
                                                   })
      end
    end

    context '有効なキーワードが与えられたとき' do
      before do
        create(:recipe, user:, name: 'パスタグラタン')
        create(:recipe, user:, name: 'カレーグラタン')
        create(:recipe, user:, name: 'チーズグラタン')

        get '/api/v1/recipes/search', params: { keyword: 'グラタン', page: 1 }
      end

      it '200を返却すること' do
        expect(response).to have_http_status(:ok)
      end

      it '一致したレシピのリストを返却すること' do
        expect(response.parsed_body.length).to eq 3
      end

      it '一致したレシピが含まれていること' do
        recipe_names = response.parsed_body.pluck('name')
        expect(recipe_names).to include('パスタグラタン', 'カレーグラタン', 'チーズグラタン')
      end
    end

    context 'ページネーションが適用されるとき' do
      before do
        create_list(:recipe, 11, user:, name: 'テストレシピ')
      end

      it '1ページ目は最大10件のアイテムを返却すること' do
        get '/api/v1/recipes/search', params: { keyword: 'テストレシピ', page: 1 }
        expect(response.parsed_body.length).to eq 10
      end

      it '2ページ目が正しい数のアイテムを返却すること' do
        get '/api/v1/recipes/search', params: { keyword: 'テストレシピ', page: 2 }
        expect(response.parsed_body.length).to eq 1
      end

      it '0がページ番号として与えられたときに200を返却すること' do
        create_list(:recipe, 10, user:, name: 'テストレシピ')

        get '/api/v1/recipes/search', params: { keyword: 'テストレシピ', page: 0 }
        expect(response).to have_http_status(:ok)
      end
    end

    context '空のキーワードが与えられたとき' do
      before do
        create(:recipe, user:, name: 'パスタ')
        create(:recipe, user:, name: 'カレー')
        create(:recipe, user:, name: 'グラタン')

        get '/api/v1/recipes/search', params: { keyword: '', page: 1 }
      end

      it '200を返却すること' do
        expect(response).to have_http_status(:ok)
      end

      it '全てのレシピのリストを返却すること' do
        expect(response.parsed_body.length).to eq 3
      end
    end

    context 'null値のキーワードが与えられたとき' do
      before do
        get '/api/v1/recipes/search', params: { keyword: nil, page: 1 }
      end

      it '422を返却すること' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
