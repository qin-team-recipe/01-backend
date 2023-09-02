require 'rails_helper'

RSpec.describe FavoriteRecipe do
  describe 'validations' do
    subject { create(:favorite_recipe, user:, recipe:) }

    let(:recipe) { create(:recipe, :with_user) }
    let(:user) { create(:user) }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:recipe_id) }
  end
end
