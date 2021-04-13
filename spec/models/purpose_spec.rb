require 'rails_helper'

RSpec.describe Purpose, type: :model do
  describe 'relationships' do
    it { should have_many :yard_purposes }
    it { should have_many(:yards).through(:yard_purposes) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end
end
