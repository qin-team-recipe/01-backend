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
end
