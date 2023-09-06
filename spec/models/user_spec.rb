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
    describe 'chef_users' do
      context 'ユーザーとシェフの両方が存在する場合' do
        let!(:users) { create_list(:user, 3) }
        let!(:chefs) { create_list(:user, 3, :chef) }
  
        it 'chefユーザーのみ取得すること' do
          expect(User.chef_users).to contain_exactly(*chefs)
        end
      end
  
      context 'chefユーザーのみ存在する場合' do
        let!(:chefs) { create_list(:user, 3, :chef) }
  
        it 'chefユーザーのみ取得すること' do
          expect(User.chef_users).to contain_exactly(*chefs)
        end
      end
  
      context '一般ユーザーのみ存在する場合' do
        let!(:users) { create_list(:user, 3) }
  
        it '何も取得しないこと' do
          expect(User.chef_users).to be_empty
        end
      end
    end
  end
end
