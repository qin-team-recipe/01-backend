require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:user_type).in_array(['user', 'chef']) }
  end

  describe 'callbacks' do
    context 'Userのレコードを作成したとき' do
      subject { create(:user) }

      it 'CartListのレコードも作成されること' do
        expect { subject }.to change(CartList, :count).by(1)
      end

      it 'CartListのレコードがじぶんメモであること' do
        subject

        expect(CartList.last).to have_attributes(
          name: 'じぶんメモ',
          position: 1,
          own_notes: true
        )
      end
    end
  end

  describe 'scope' do
    describe '.chef_users' do
      subject { described_class.chef_users }

      context 'ユーザーとシェフの両方が存在する場合' do
        before do
          create_list(:user, 3)
        end

        it 'chefユーザーのみ取得すること' do
          chefs = create_list(:user, 3, :chef)
          expect(subject).to match_array(chefs)
        end
      end

      context 'chefユーザーのみ存在する場合' do
        let!(:chefs) { create_list(:user, 3, :chef) }

        it 'chefユーザーのみ取得すること' do
          expect(subject).to match_array(chefs)
        end
      end

      context '一般ユーザーのみ存在する場合' do
        before do
          create_list(:user, 3)
        end

        it '何も取得しないこと' do
          expect(subject).to be_empty
        end
      end
    end
  end

  describe 'followers.count' do
    let(:user) { create(:user) }
    let(:followers) { create_list(:user, 3) }

    before do
      followers.each { |follower| follower.follow(user) }
    end

    context 'ユーザーがフォロワーを持つ場合' do
      it '正確なフォロワーの数を返すこと' do
        expect(user.followers.count).to eq(3)
      end
    end

    context 'ユーザーが自分自身をフォローしようとする場合' do
      it 'ユーザーが自身をフォローできないこと' do
        user.follow(user)
        expect(user.following).not_to include(user)
      end
    end

    context 'ユーザーが他のユーザーをアンフォローする場合' do
      before do
        followers.first.unfollow(user)
      end

      it 'フォロワーカウントを正確に減らすこと' do
        expect(user.followers.count).to eq(2)
      end
    end

    context 'ユーザーがフォロワーを持たない場合' do
      before do
        followers.each { |follower| follower.unfollow(user) }
      end

      it 'フォロワーカウントは0であること' do
        expect(user.followers.count).to eq(0)
      end
    end
  end

  describe 'recipes.count' do
    let(:user) { create(:user) }
    let!(:recipes) { create_list(:recipe, 3, user:) }

    context 'ユーザーがレシピを持つ場合' do
      it '正確なレシピの数を返すこと' do
        expect(user.recipes.count).to eq(3)
      end
    end

    context 'ユーザーがレシピを削除する場合' do
      before do
        recipes.first.destroy
      end

      it 'レシピカウントを正確に減らすこと' do
        expect(user.recipes.count).to eq(2)
      end
    end

    context 'ユーザーがすべてのレシピを削除する場合' do
      before do
        recipes.each(&:destroy)
      end

      it 'レシピカウントは0であること' do
        expect(user.recipes.count).to eq(0)
      end
    end
  end
end
