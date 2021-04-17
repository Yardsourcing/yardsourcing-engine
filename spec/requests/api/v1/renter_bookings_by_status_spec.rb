require 'rails_helper'
RSpec.describe 'Renter Bookings by Status API' do
  before :each do
    create_list(:booking, 2, status: 'pending')
    create_list(:booking, 2, status: 'rejected')
    create_list(:booking, 2, status: 'approved')
  end

  describe 'happy path' do
    it 'returns 2 bookings with pending status' do
      get "/api/v1/renters/1/bookings?status=pending"

      expect(response).to be_successful

      bookings = JSON.parse(response.body, symbolize_names:true)

      expect(bookings).to be_a(Hash)
      expect(bookings[:data]).to be_an(Array)
      expect(bookings[:data].count).to eq(2)
      bookings[:data].each do |booking|
        expect(booking[:type]).to eq('booking')
        expect(booking[:attributes].count).to eq(8)
        expect(booking[:attributes]).to have_key(:status)
        expect(booking[:attributes]).to have_key(:booking_name)
        expect(booking[:attributes]).to have_key(:date)
        expect(booking[:attributes]).to have_key(:description)
        expect(booking[:attributes]).to have_key(:duration)
        expect(booking[:attributes]).to have_key(:time)
        expect(booking[:attributes]).to have_key(:renter_id)
        expect(booking[:attributes]).to have_key(:yard_id)
        expect(booking[:attributes][:renter_id]).to be_a(Integer)
        expect(booking[:attributes][:yard_id]).to be_a(Integer)
        expect(booking[:attributes][:duration]).to be_a(Integer)
        expect(booking[:attributes][:description]).to be_a(String)
        expect(booking[:attributes][:status]).to be_a(String)
        expect(booking[:attributes][:booking_name]).to be_a(String)
        expect(booking[:attributes][:time]).to be_a(String)
        expect(booking[:attributes][:status]).to eq('pending')
      end
    end

    it 'returns 2 bookings with rejected status' do
      get "/api/v1/renters/1/bookings?status=rejected"

      expect(response).to be_successful

      bookings = JSON.parse(response.body, symbolize_names:true)

      expect(bookings).to be_a(Hash)
      expect(bookings[:data]).to be_an(Array)
      expect(bookings[:data].count).to eq(2)
      bookings[:data].each do |booking|
        expect(booking[:type]).to eq('booking')
        expect(booking[:attributes].count).to eq(8)
        expect(booking[:attributes]).to have_key(:status)
        expect(booking[:attributes]).to have_key(:booking_name)
        expect(booking[:attributes]).to have_key(:date)
        expect(booking[:attributes]).to have_key(:description)
        expect(booking[:attributes]).to have_key(:duration)
        expect(booking[:attributes]).to have_key(:time)
        expect(booking[:attributes]).to have_key(:renter_id)
        expect(booking[:attributes]).to have_key(:yard_id)
        expect(booking[:attributes][:renter_id]).to be_a(Integer)
        expect(booking[:attributes][:yard_id]).to be_a(Integer)
        expect(booking[:attributes][:duration]).to be_a(Integer)
        expect(booking[:attributes][:description]).to be_a(String)
        expect(booking[:attributes][:status]).to be_a(String)
        expect(booking[:attributes][:booking_name]).to be_a(String)
        expect(booking[:attributes][:time]).to be_a(String)
        expect(booking[:attributes][:status]).to eq('rejected')
      end
    end

    it 'returns 2 bookings with pending approved' do
      get "/api/v1/renters/1/bookings?status=approved"

      expect(response).to be_successful

      bookings = JSON.parse(response.body, symbolize_names:true)

      expect(bookings).to be_a(Hash)
      expect(bookings[:data]).to be_an(Array)
      expect(bookings[:data].count).to eq(2)
      bookings[:data].each do |booking|
        expect(booking[:type]).to eq('booking')
        expect(booking[:attributes].count).to eq(8)
        expect(booking[:attributes]).to have_key(:status)
        expect(booking[:attributes]).to have_key(:booking_name)
        expect(booking[:attributes]).to have_key(:date)
        expect(booking[:attributes]).to have_key(:description)
        expect(booking[:attributes]).to have_key(:duration)
        expect(booking[:attributes]).to have_key(:time)
        expect(booking[:attributes]).to have_key(:renter_id)
        expect(booking[:attributes]).to have_key(:yard_id)
        expect(booking[:attributes][:renter_id]).to be_a(Integer)
        expect(booking[:attributes][:yard_id]).to be_a(Integer)
        expect(booking[:attributes][:duration]).to be_a(Integer)
        expect(booking[:attributes][:description]).to be_a(String)
        expect(booking[:attributes][:status]).to be_a(String)
        expect(booking[:attributes][:booking_name]).to be_a(String)
        expect(booking[:attributes][:time]).to be_a(String)
        expect(booking[:attributes][:status]).to eq('approved')
      end
    end
  end

  describe 'sad path' do
    it 'returns an empty array if no bookings exist' do
      booking = create(:booking, renter_id: 2)
      create_list(:booking, 7, renter_id: 2)
      create_list(:booking, 2, renter_id: 2)

      get "/api/v1/renters/3/bookings?status=pending"

      expect(response).to be_successful
      bookings = JSON.parse(response.body, symbolize_names:true)
      expect(bookings).to be_a(Hash)
      expect(bookings[:data]).to be_a(Hash)
      expect(bookings[:data].empty?).to eq(true)
    end

    it 'errors out when param is passed with nothing' do
      booking = create(:booking, renter_id: 2)
      create_list(:booking, 7, renter_id: 2)
      create_list(:booking, 2, renter_id: 2)

      get "/api/v1/renters/1/bookings?status="

      bookings = JSON.parse(response.body, symbolize_names:true)
      expect(bookings).to be_a(Hash)
      expect(bookings[:error]).to eq("Need status")
    end
  end
end
