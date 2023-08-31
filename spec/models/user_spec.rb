require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:user_type).in_array(['user', 'chef']) }
  end

  describe 'callbacks' do
    context 'Userのレコードを作成したとき' do
      subject { create(:user) }

      it 'CartListのレコードも作成されること' do
        expect { subject }.to change { CartList.count }.by(1)
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
end
