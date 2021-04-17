require 'rails_helper'

RSpec.describe 'Bookings API SPEC'do
  describe 'happy path' do
    it 'can return a specific booking by id' do
      create_list(:booking, 10)
      booking_id = Booking.all.first
      get "/api/v1/bookings/#{booking_id.id}"
      expect(response).to be_successful
      booking = JSON.parse(response.body, symbolize_names:true)
      expect(booking).to be_a(Hash)
      expect(booking[:data]).to be_a(Hash)
      expect(booking[:data].count).to eq(3)
      expect(booking[:data][:attributes].count).to eq(8)
      expect(booking[:data][:attributes]).to have_key(:status)
      expect(booking[:data][:attributes]).to have_key(:booking_name)
      expect(booking[:data][:attributes]).to have_key(:date)
      expect(booking[:data][:attributes]).to have_key(:description)
      expect(booking[:data][:attributes]).to have_key(:duration)
      expect(booking[:data][:attributes]).to have_key(:time)
      expect(booking[:data][:attributes]).to have_key(:renter_id)
      expect(booking[:data][:attributes]).to have_key(:yard_id)
      expect(booking[:data][:attributes][:renter_id]).to be_a(Integer)
      expect(booking[:data][:attributes][:yard_id]).to be_a(Integer)
      expect(booking[:data][:attributes][:duration]).to be_a(Integer)
      expect(booking[:data][:attributes][:description]).to be_a(String)
      expect(booking[:data][:attributes][:status]).to be_a(String)
      expect(booking[:data][:attributes][:booking_name]).to be_a(String)
      expect(booking[:data][:attributes][:time]).to be_a(String)
    end

    it 'returns the correct booking' do
      create_list(:booking, 10)
      booking = create(:booking, status: :approved, booking_name: "fun", duration:100)
      special_booking = Booking.all.last
      get "/api/v1/bookings/#{special_booking.id}"
      expect(response).to be_successful
      booking = JSON.parse(response.body, symbolize_names:true)
      expect(booking[:data][:attributes][:renter_id]).to eq(special_booking.renter_id)
      expect(booking[:data][:attributes][:yard_id]).to eq(special_booking.yard_id)
      expect(booking[:data][:attributes][:duration]).to eq(special_booking.duration)
      expect(booking[:data][:attributes][:status]).to eq(special_booking.status)
      expect(booking[:data][:attributes][:booking_name]).to eq(special_booking.booking_name)
      expect(booking[:data][:attributes][:description]).to eq(special_booking.description)
    end
  end

  describe 'sad path' do
    it 'errors out when no bookings match id' do
      create_list(:booking, 10)
      booking = create(:booking, status: :approved, booking_name: "fun", duration:100)
      get "/api/v1/bookings/akjfkjkjkd"
      expect(response.status).to eq(400)
      error = JSON.parse(response.body, symbolize_names:true)
      expect(error).to be_a(Hash)
      expect(error[:error]).to be_a(String)
    end

    it 'should return an empty array if no ids exist' do
      create_list(:booking, 10)
      booking = create(:booking, status: :approved, booking_name: "fun", duration:100)
      get "/api/v1/bookings/100000000"
      expect(response.status).to eq(404)
      expect(response.body).to eq("Record not found")
    end
  end
end
