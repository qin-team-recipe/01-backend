require 'rails_helper'

RSpec.describe CartList do
  describe 'validations' do
    describe '.ensure_single_own_notes' do
      subject { build(:cart_list, user:, recipe:, name:, own_notes:, position:) }

      context 'じぶんメモが存在している場合' do # userを作成する際にcallbackでじぶんメモを作成している
        context '新たにじぶんメモを作成する場合' do
          let(:user) { create(:user) }
          let(:recipe) { nil }
          let(:name) { 'じぶんメモ' }
          let(:own_notes) { true }
          let(:position) { 1 }

          it { is_expected.to be_invalid }
        end

        context 'じぶんメモ以外を作成する場合' do
          let(:user) { create(:user) }
          let(:recipe) { create(:recipe, user:) }
          let(:name) { 'デスノート' }
          let(:own_notes) { false }
          let(:position) { 2 }

          it { is_expected.to be_valid }
        end
      end

      context 'じぶんメモが存在していない場合' do # userを作成していないことを意味する
        let(:user) { build(:user) }
        let(:recipe) { nil }
        let(:name) { 'じぶんメモ' }
        let(:own_notes) { true }
        let(:position) { 1 }

        it { is_expected.to be_valid }
      end
    end

    describe '.own_notes_values' do
      subject { build(:cart_list, user:, recipe:, name:, own_notes:, position:) }

      context 'じぶんメモを作成する場合' do
        let(:user) { build(:user) }
        let(:own_notes) { true }

        context 'recipeが紐づいている場合' do
          let(:recipe) { create(:recipe, user:) }
          let(:name) { 'じぶんメモ' }
          let(:position) { 1 }

          it { is_expected.to be_invalid }
        end

        context 'nameが「じぶんメモ」ではない場合' do
          let(:recipe) { nil }
          let(:name) { 'じぶんメモではない' }
          let(:position) { 1 }

          it { is_expected.to be_invalid }
        end

        context 'positionが1ではない場合' do
          let(:recipe) { nil }
          let(:name) { 'じぶんメモ' }
          let(:position) { 2 }

          it { is_expected.to be_invalid }
        end
      end
    end
  end
end
