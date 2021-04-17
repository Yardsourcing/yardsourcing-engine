require 'rails_helper'

RSpec.describe Purpose, type: :model do
  describe 'relationships' do
    it { should have_many :yard_purposes }
    it { should have_many(:yards).through(:yard_purposes) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }

    describe 'downcase name' do
      it "downcases the name before save" do
        purpose = Purpose.create!(name: 'SIGH')

        expect(purpose.name).to eq('sigh')
      end
    end
  end
end
