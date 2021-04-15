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
end
