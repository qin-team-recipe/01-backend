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

        expect(response.parsed_body[0]).to include({ 'id' => recipe.id })
      end
    end
  end
end
