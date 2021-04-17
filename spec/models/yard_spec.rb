require 'rails_helper'

RSpec.describe Yard, type: :model do
  describe 'relationships' do
    it { should have_many :yard_purposes }
    it { should have_many :bookings }
    it { should have_many(:purposes).through(:yard_purposes) }
  end

  describe 'validations' do
    it { should validate_presence_of :host_id }
    it { should validate_presence_of :name }
    it { should validate_presence_of :street_address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zipcode }
    it { should validate_presence_of :price }
    it { should validate_presence_of :availability }
    it { should validate_presence_of :payment }
    it { should validate_numericality_of(:host_id).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end

  describe 'class methods' do
    describe 'by_zipcode' do
      it "returns all yards with defined zipcode" do
        yards1 = create_list(:yard, 2, zipcode: '23456')
        yards2 = create(:yard, zipcode: '45678')

        expect(Yard.by_zipcode('23456')).to eq([yards1.first, yards1.last])
        expect(Yard.by_zipcode('23456').include?(yards2)).to eq(false)
      end
    end

    describe 'by_zipcode_and_purposes' do
      it "returns all yard with matching zipcode and purposes" do
        purposes = create_list(:purpose, 3)
        yards1 = create_list(:yard, 2, zipcode: '23456')
        yards1.first.purposes << [purposes.second]
        yards1.last.purposes << [purposes.last, purposes.first]
        yards2 = create(:yard, zipcode: '45678')
        zipcode = '23456'
        purpose_search1 = purposes.map(&:name)
        purpose_search2 = [purposes.second.name]

        results1 = Yard.by_zipcode_and_purposes(zipcode, purpose_search1)
        results2 = Yard.by_zipcode_and_purposes(zipcode, purpose_search2)

        expect(results1).to eq([yards1.first, yards1.last])
        expect(results2).to eq([yards1.first])
        expect(results2.include?(yards1.last)).to eq(false)
      end
    end
  end
end
