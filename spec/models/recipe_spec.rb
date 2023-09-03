require 'rails_helper'

RSpec.describe Recipe do
  describe 'scope' do
    describe '.popular_in_last_3_days' do
      subject { described_class.popular_in_last_3_days }

      let!(:recipe_gratan) { create(:recipe, :with_user, name: 'グラタン') }
      let!(:recipe_pasta) { create(:recipe, :with_user, name: 'パスタ') }
      let!(:recipe_curry) { create(:recipe, :with_user, name: 'カレー') }

      context 'いいねの数に差がある場合' do
        before do
          create_list(:favorite_recipe, 5, :with_user, recipe: recipe_gratan, created_at: Time.current.ago(2.days))
          create_list(:favorite_recipe, 3, :with_user, recipe: recipe_pasta, created_at: Time.current.yesterday)
          create_list(:favorite_recipe, 2, :with_user, recipe: recipe_curry, created_at: Time.current)
        end

        it 'いいね数が多い順に取得できること' do
          expect(subject).to eq [recipe_gratan, recipe_pasta, recipe_curry]
        end
      end

      context 'いいねの数に差がない場合' do
        before do
          create(:favorite_recipe, :with_user, recipe: recipe_curry, created_at: Time.current.ago(2.days))
          create(:favorite_recipe, :with_user, recipe: recipe_pasta, created_at: Time.current.yesterday)
          create(:favorite_recipe, :with_user, recipe: recipe_gratan, created_at: Time.current)
        end

        it '作成順に取得できること' do
          expect(subject).to eq [recipe_gratan, recipe_pasta, recipe_curry]
        end
      end

      context '3日以内にいいねされているレシピがない場合' do
        before do
          create(:favorite_recipe, :with_user, recipe: recipe_gratan, created_at: Time.current.ago(3.days))
          create(:favorite_recipe, :with_user, recipe: recipe_pasta, created_at: Time.current.ago(3.days))
          create(:favorite_recipe, :with_user, recipe: recipe_curry, created_at: Time.current.ago(3.days))
        end

        it 'レコードが取得できないこと' do
          expect(subject).to eq []
        end
      end
    end

    describe '.not_favorited_in_last_3_days' do
      subject { described_class.not_favorited_in_last_3_days }

      let!(:recipe_gratan) { create(:recipe, :with_user, name: 'グラタン') }

      context '3日以内にいいねされた場合' do
        before do
          create(:favorite_recipe, :with_user, recipe: recipe_gratan, created_at: Time.current.ago(2.days))
        end

        it 'レコードを取得できないこと' do
          expect(subject).to eq []
        end
      end

      context '3日より前にいいねされた場合' do
        before do
          create(:favorite_recipe, :with_user, recipe: recipe_gratan, created_at: Time.current.ago(3.days))
        end

        it 'レコードを取得できること' do
          expect(subject).to eq [recipe_gratan]
        end
      end

      context 'いいねされていない場合' do
        it 'レコードを取得できること' do
          expect(subject).to eq [recipe_gratan]
        end
      end
    end
  end

  describe '#ordered_by_recent_favorites_and_others' do
    subject { described_class.ordered_by_recent_favorites_and_others }

    let!(:recipe_gratan) { create(:recipe, :with_user, name: 'グラタン') }
    let!(:recipe_pasta) { create(:recipe, :with_user, name: 'パスタ') }
    let!(:recipe_curry) { create(:recipe, :with_user, name: 'カレー') }

    context 'すべてのレシピが3日以内にいいねされている場合' do
      before do
        create_list(:favorite_recipe, 5, :with_user, recipe: recipe_gratan, created_at: Time.current.ago(2.days))
        create_list(:favorite_recipe, 3, :with_user, recipe: recipe_pasta, created_at: Time.current.yesterday)
        create_list(:favorite_recipe, 2, :with_user, recipe: recipe_curry, created_at: Time.current)
      end

      it 'いいね数が多い順に取得できること' do
        expect(subject).to eq [recipe_gratan, recipe_pasta, recipe_curry]
      end
    end

    context 'すべてのレシピのいいねが3日よりも前の場合' do
      before do
        create_list(:favorite_recipe, 5, :with_user, recipe: recipe_gratan, created_at: Time.current.ago(3.days))
        create_list(:favorite_recipe, 3, :with_user, recipe: recipe_pasta, created_at: Time.current.ago(4.days))
        create_list(:favorite_recipe, 2, :with_user, recipe: recipe_curry, created_at: Time.current.ago(5.days))
      end

      it 'レシピの作成順に取得できること' do
        expect(subject).to eq [recipe_gratan, recipe_pasta, recipe_curry]
      end
    end

    context 'すべてのレシピがいいねされていない場合' do
      it 'レシピの作成順に取得できること' do
        expect(subject).to eq [recipe_gratan, recipe_pasta, recipe_curry]
      end
    end

    context 'すべて混在している場合' do
      before do
        create(:favorite_recipe, :with_user, recipe: recipe_gratan, created_at: Time.current.ago(2.days))
        create_list(:favorite_recipe, 3, :with_user, recipe: recipe_pasta, created_at: Time.current.ago(5.days))
      end

      it 'すべてのレコードを取得いいね多い順 -> 作成順の優先順に取得できること' do
        expect(subject).to eq [recipe_gratan, recipe_pasta, recipe_curry]
      end
    end
  end
end
