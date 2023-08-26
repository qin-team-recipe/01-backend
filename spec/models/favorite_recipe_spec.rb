require 'rails_helper'

RSpec.describe FavoriteRecipe do
  describe 'validations' do
    subject { create(:favorite_recipe, user:, recipe:) }

    let(:recipe) { create(:recipe, :with_user) }
    let(:user) { create(:user) }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:recipe_id) }
  end

  describe 'scope' do
    describe '.created_in_last_3_days' do
      subject { described_class.created_in_last_3_days }

      context 'レコードが今日作成された場合' do
        let!(:favorite_recipe_created_today) { create(:favorite_recipe, :with_user_and_recipe) }

        it 'レコードが取得できること' do
          expect(subject).to eq [favorite_recipe_created_today]
        end
      end

      context 'レコードが2日前に作成された場合' do
        let!(:favorite_recipe_created_2_days_ago) { create(:favorite_recipe, :with_user_and_recipe, created_at: Time.current.ago(2.days)) }

        it 'レコードが取得できること' do
          expect(subject).to eq [favorite_recipe_created_2_days_ago]
        end
      end

      context 'レコードが3日前に作成された場合' do
        before do
          create(:favorite_recipe, :with_user_and_recipe, created_at: Time.current.ago(3.days))
        end

        it 'レコードが取得できないこと' do
          expect(subject).to eq []
        end
      end
    end
  end
end
