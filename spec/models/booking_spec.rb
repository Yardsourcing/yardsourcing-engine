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
    it { should validate_presence_of :renter_email }
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
    it 'returns bookings after todays date in upcoming order ' do
      booking2 = create(:booking, status: :approved, date: (Date.today + 10))
      booking3 = create(:booking, status: :pending, date: (Date.today + 15))
      booking = create(:booking, status: :pending, date: (Date.today + 20))
      expect(Booking.find_by_renter_and_status(1, 'pending')).to eq([booking, booking3])
    end

    it 'returns bookings by renter_id' do
      booking1 = create(:booking, status: :pending)
      booking2 = create(:booking, status: :approved)
      booking3 = create(:booking, status: :rejected)
      expect(Booking.find_by_renter(1)).to eq([booking1, booking2, booking3])
    end

    it 'returns bookings after todays date in upcoming order' do
      booking1 = create(:booking, status: :pending, date: (Date.today + 20))
      booking2 = create(:booking, status: :approved, date: (Date.today + 10))
      booking3 = create(:booking, status: :rejected, date: (Date.today + 15))
      expect(Booking.find_by_renter(1)).to eq([booking3, booking2, booking1])
    end

    it 'returns bookings by host_id and status' do
      yard = create(:yard, host_id: 1)
      booking = create(:booking, status: :pending, yard_id: yard.id)
      expect(Booking.find_by_host_and_status(1, 'pending')).to eq([booking])
    end

    it 'returns bookings by host_id' do
      yard = create(:yard, host_id: 1)
      booking1 = create(:booking, status: :pending, yard_id: yard.id)
      booking2 = create(:booking, status: :approved, yard_id: yard.id)
      booking3 = create(:booking, status: :rejected, yard_id: yard.id)
      expect(Booking.find_by_host(1)).to eq([booking1, booking2, booking3])
    end

    it 'returns bookings by host_id and status after todays date in upcoming order' do
      yard = create(:yard, host_id: 1)
      booking = create(:booking, status: :pending, yard_id: yard.id, date: (Date.today + 10))
      booking2 = create(:booking, status: :pending, yard_id: yard.id, date: (Date.today + 20))
      booking3 = create(:booking, status: :approved, yard_id: yard.id, date: (Date.today + 15))
      expect(Booking.find_by_host_and_status(1, 'pending')).to eq([booking2, booking])
    end

    it 'returns bookings by host_id after todays date in upcoming order' do
      yard = create(:yard, host_id: 1)
      booking1 = create(:booking, status: :pending, yard_id: yard.id, date: (Date.today + 10))
      booking2 = create(:booking, status: :approved, yard_id: yard.id, date: (Date.today + 20))
      booking3 = create(:booking, status: :rejected, yard_id: yard.id, date: (Date.today + 15))
      expect(Booking.find_by_host(1)).to eq([booking2, booking3, booking1])
    end

    it 'should throw an error if the email is not in the standard format' do
      yard = create(:yard)
      booking = yard.bookings.new(
        renter_email: "Not an Eamil",
        status: :pending,
        booking_name: "My Booking",
        date: Time.new(2020),
        time: Time.now,
        duration: 2,
        description: ""
      )
      expect(booking.save).to eq(false)
      expect(booking.errors[:renter_email].to_sentence).to eq("is invalid")
    end
  end
end
