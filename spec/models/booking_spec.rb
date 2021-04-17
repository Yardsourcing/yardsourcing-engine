require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'relationships' do
    it { should belong_to :yard }

  end

  describe 'validations' do
    it { should validate_presence_of :renter_id }
    it { should validate_presence_of :booking_name }
    it { should validate_presence_of :date }
    it { should validate_presence_of :time }
    it { should validate_presence_of :duration }
    it { should validate_presence_of :description }
    it { should validate_numericality_of(:renter_id).is_greater_than_or_equal_to(0) }

    it "should throw an error if the date is in the past (before today's date)" do
      yard = create(:yard)
      booking = yard.bookings.new(
        status: :pending,
        booking_name: "My Booking",
        date: Time.new(2020),
        time: Time.now,
        duration: 2,
        description: ""
      )
      expect(booking.save).to eq(false)
      expect(booking.errors[:date].to_sentence).to eq("Booking Date can't be in the past")
    end

    it 'status can be pending' do
      booking = create(:booking)
      expect(booking.status).to eq("pending")
      expect(booking.pending?).to eq(true)
      expect(booking.approved?).to eq(false)
      expect(booking.rejected?).to eq(false)
    end

    it 'status can be approved' do
      booking = create(:booking, status: :approved)
      expect(booking.status).to eq("approved")
      expect(booking.pending?).to eq(false)
      expect(booking.approved?).to eq(true)
      expect(booking.rejected?).to eq(false)
    end

    it 'status can be rejected' do
      booking = create(:booking, status: :rejected)
      expect(booking.status).to eq("rejected")
      expect(booking.pending?).to eq(false)
      expect(booking.approved?).to eq(false)
      expect(booking.rejected?).to eq(true)
    end

    it 'returns bookings by renter_id and status' do
      booking = create(:booking, status: :pending)
      expect(Booking.find_by_renter_and_status(1, 'pending')).to eq([booking])
    end
  end
end
