require 'rails_helper'

RSpec.describe FavoriteRecipe do
  describe 'バリデーション' do
    subject { create(:favorite_recipe, user: user, recipe: recipe) }

    let(:recipe) { create(:recipe, :with_user) }
    let(:user) { create(:user) }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:recipe_id) }
  end
end

