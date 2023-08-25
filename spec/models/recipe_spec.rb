require 'rails_helper'

RSpec.describe Recipe do
  describe 'バリデーション' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(100) }
    it { is_expected.to validate_length_of(:description).is_at_most(256) }
    it { is_expected.not_to allow_value(nil).for(:is_draft) }
    it { is_expected.not_to allow_value(nil).for(:is_public) }
  end
end
