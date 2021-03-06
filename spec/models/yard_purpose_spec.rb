require 'rails_helper'

RSpec.describe YardPurpose, type: :model do
  describe 'relationships' do
    it { should belong_to :yard }
    it { should belong_to :purpose }
  end

  describe 'validations' do
    it 'validates uniqueness of purpose for a yard' do
      create(:yard_purpose)
      should validate_uniqueness_of(:purpose_id).scoped_to(:yard_id)
    end
  end

  describe "class methods" do
    describe "::find_unselected_purposes" do
      it "find all purposes that have been unselected by the user" do
        Yard.destroy_all
        Purpose.destroy_all
        YardPurpose.destroy_all
        yard = create(:yard)
        purposes = create_list(:purpose, 3)
        yard_purpose = create(:yard_purpose, yard_id: yard.id, purpose_id: purposes.first.id)

        expect(yard.yard_purposes.find_unselected_purposes([purposes.second.id, purposes.last.id])).to eq([yard_purpose.id])
      end
    end
  end
end
