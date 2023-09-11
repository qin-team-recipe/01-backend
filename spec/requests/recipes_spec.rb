require 'rails_helper'

RSpec.describe 'Recipes' do
  describe 'GET /recipes' do
    context 'レシピのレコードがあるとき' do
      context 'レシピが公開中の場合' do
        let!(:recipe) { create(:recipe, user:, is_public: true) }

        context '有名シェフが作成したレシピの場合' do
          let(:user) { create(:user, user_type: 'chef') }

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

        context '一般シェフが作成したレシピの場合' do
          let(:user) { create(:user, user_type: 'user') }

          it '200を返却すること' do
            get api_v1_recipes_path
            expect(response).to have_http_status(:ok)
          end

          it 'レスポンスの中身は0件であること' do
            get api_v1_recipes_path

            expect(response.parsed_body.length).to eq 0
          end
        end
      end

      context 'レシピが非公開中の場合' do
        before do
          create(:recipe, :with_chef, is_public: false)
        end

        it '200を返却すること' do
          get api_v1_recipes_path
          expect(response).to have_http_status(:ok)
        end

        it 'レスポンスの中身は0件であること' do
          get api_v1_recipes_path

          expect(response.parsed_body.length).to eq 0
        end
      end
    end
  end

  describe 'GET /recipes/:id' do
    context 'レシピのレコードがあるとき' do
      let!(:recipe) { create(:recipe, :with_chef) }
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

    context 'レシピのレコードがあるとき' do
      context 'レシピが公開中の場合' do
        let!(:recipe) { create(:recipe, user:, is_public: true) }

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

      context 'レシピが非公開中の場合' do
        before do
          create(:recipe, :with_user, is_public: false)
        end

        it '200を返却すること' do
          get popular_recipes_api_v1_user_path(user)
          expect(response).to have_http_status(:ok)
        end

        it 'レスポンスの中身は0件であること' do
          get popular_recipes_api_v1_user_path(user)

          expect(response.parsed_body.length).to eq 0
        end
      end
    end
  end

  describe 'GET /users/:user_id/new_arrival_recipes' do
    let(:user) { create(:user) }

    context 'レシピのレコードがあるとき' do
      context 'レシピが公開中の場合' do
        let!(:recipe) { create(:recipe, user:, is_public: true) }

        it '200を返却すること' do
          get new_arrival_recipes_api_v1_user_path(user)
          expect(response).to have_http_status(:ok)
        end

        it 'レスポンスの中身は1件のみであること' do
          get new_arrival_recipes_api_v1_user_path(user)

          expect(response.parsed_body.length).to eq 1
        end

        it 'recipeのレコードを返却すること' do
          get new_arrival_recipes_api_v1_user_path(user)

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

      context 'レシピが非公開中の場合' do
        before do
          create(:recipe, :with_user, is_public: false)
        end

        it '200を返却すること' do
          get new_arrival_recipes_api_v1_user_path(user)
          expect(response).to have_http_status(:ok)
        end

        it 'レスポンスの中身は0件であること' do
          get new_arrival_recipes_api_v1_user_path(user)

          expect(response.parsed_body.length).to eq 0
        end
      end
    end
  end
end
