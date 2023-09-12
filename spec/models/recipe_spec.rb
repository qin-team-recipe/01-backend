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

    describe '.popular_recipes_by_user' do
      subject { described_class.popular_recipes_by_user(user.id) }

      let(:user) { create(:user) }

      context 'いいねの数に差がある場合' do
        let!(:recipe_gratan) { create(:recipe, user:, name: 'グラタン') }
        let!(:recipe_pasta) { create(:recipe, user:, name: 'パスタ') }
        let!(:recipe_curry) { create(:recipe, user:, name: 'カレー') }

        let!(:another_user_recipe) { create(:recipe, :with_user, name: 'おにぎり') }

        before do
          create_list(:favorite_recipe, 5, :with_user, recipe: recipe_gratan, created_at: Time.current.ago(2.days))
          create_list(:favorite_recipe, 3, :with_user, recipe: recipe_pasta, created_at: Time.current.yesterday)
          create_list(:favorite_recipe, 2, :with_user, recipe: recipe_curry, created_at: Time.current)
        end

        it 'いいね数が多い順に取得できること' do
          expect(subject).to eq [recipe_gratan, recipe_pasta, recipe_curry]
        end

        it '他のユーザーのレシピが取得されないこと' do
          expect(subject).not_to include(another_user_recipe)
        end
      end

      context 'いいねの数に差がない場合' do
        let!(:recipe_gratan) { create(:recipe, user:, name: 'グラタン') }
        let!(:recipe_pasta) { create(:recipe, user:, name: 'パスタ') }
        let!(:recipe_curry) { create(:recipe, user:, name: 'カレー') }

        before do
          create(:favorite_recipe, :with_user, recipe: recipe_curry, created_at: Time.current.ago(2.days))
          create(:favorite_recipe, :with_user, recipe: recipe_pasta, created_at: Time.current.yesterday)
          create(:favorite_recipe, :with_user, recipe: recipe_gratan, created_at: Time.current)
        end

        it '作成順に取得できること' do
          expect(subject).to eq [recipe_gratan, recipe_pasta, recipe_curry]
        end
      end

      context 'いいねされているレシピがない場合' do
        let!(:recipe_gratan) { create(:recipe, user:, name: 'グラタン') }
        let!(:recipe_pasta) { create(:recipe, user:, name: 'パスタ') }
        let!(:recipe_curry) { create(:recipe, user:, name: 'カレー') }

        it '作成順に取得できること' do
          expect(subject).to eq [recipe_gratan, recipe_pasta, recipe_curry]
        end
      end
    end

    describe '.by_chef' do
      subject { described_class.by_chef }

      context 'chefとuserが作成したレシピが混在している場合' do
        let!(:recipe_gratan) { create(:recipe, :with_chef, name: 'グラタン') }
        let!(:recipe_pasta) { create(:recipe, :with_chef, name: 'パスタ') }

        before do
          create(:recipe, :with_user, name: 'カレー')
        end

        it 'chefのレシピのみ取得できること' do
          expect(subject).to eq [recipe_gratan, recipe_pasta]
        end
      end
    end
  end

  describe '.new_arrival_recipes_by_user' do
    subject { described_class.new_arrival_recipes_by_user(user.id) }

    let(:user) { create(:user) }

    let!(:recipe_gratan) { create(:recipe, user:, name: 'グラタン', created_at: Time.current.ago(3.days)) }
    let!(:recipe_pasta) { create(:recipe, user:, name: 'パスタ', created_at: Time.current.ago(2.days)) }
    let!(:recipe_curry) { create(:recipe, user:, name: 'カレー', created_at: Time.current.ago(1.day)) }

    let!(:another_user_recipe) { create(:recipe, :with_user, name: 'おにぎり') }

    it '作成日時の新しい順に取得できること' do
      expect(subject).to eq [recipe_curry, recipe_pasta, recipe_gratan]
    end

    it '他のユーザーのレシピが取得されないこと' do
      expect(subject).not_to include(another_user_recipe)
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

  describe '#is_favorite?' do
    subject { recipe.is_favorite?(user) }

    let!(:recipe) { create(:recipe, :with_user) }

    context 'レシピにお気に入りがついている場合' do
      let!(:favorited_user) { create(:user) }

      before do
        create(:favorite_recipe, user: favorited_user, recipe:)
      end

      context '引数のuserとレシピをお気に入りにしているユーザーが同じ場合' do
        let(:user) { favorited_user }

        it 'trueが返却されること' do
          expect(subject).to be true
        end
      end

      context '引数のuserとレシピをお気に入りにしているユーザーが異なる場合' do
        let(:user) { create(:user) }

        it 'falseが返却されること' do
          expect(subject).to be false
        end
      end
    end

    context 'レシピにお気に入りがついていない場合' do
      let(:user) { create(:user) }

      it 'falseが返却されること' do
        expect(subject).to be false
      end
    end
  end
end
