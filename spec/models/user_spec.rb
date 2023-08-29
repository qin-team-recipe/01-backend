require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_inclusion_of(:user_type).in_array(['user', 'chef']) }
  end
end
