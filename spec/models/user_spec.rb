require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:user_type).in_array(['user', 'chef']) }
  end
end
