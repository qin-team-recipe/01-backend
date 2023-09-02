require 'rails_helper'

RSpec.describe Step do
  describe 'validations' do
    subject { create(:step, recipe:) }

    let(:recipe) { create(:recipe, :with_user) }

    it { is_expected.to validate_uniqueness_of(:position).scoped_to(:recipe_id) }
  end
end
