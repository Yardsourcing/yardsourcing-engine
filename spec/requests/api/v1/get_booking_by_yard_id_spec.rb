require 'rails_helper'

RSpec.describe 'Yard API SPEC'do
  describe 'happy path' do
    it 'returns correct data types by a yard id' do
      yard = create(:yard)
      booking = create(:booking)
      create_list(:booking, 10, yard_id: yard.id)
      get "/api/v1/yards/#{yard.id}/bookings"
      expect(response).to be_successful
      bookings = JSON.parse(response.body, symbolize_names:true)
      expect(bookings).to be_a(Hash)
      expect(bookings[:data]).to be_an(Array)
      expect(bookings[:data].count).to eq(10)
      bookings[:data].each do |booking|
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
      end
    end

    it 'returns the correct bookings and nothing else' do
      yard = create(:yard)
      booking = create(:booking)
      create_list(:booking, 7, yard_id: yard.id)
      create_list(:booking, 2)
      get "/api/v1/yards/#{yard.id}/bookings"
      expect(response).to be_successful
      bookings = JSON.parse(response.body, symbolize_names:true)
      ids = bookings[:data].pluck(:id)
      stringify = booking.id.to_s
      stringify2 = Booking.last.id.to_s
      stringify3 = Booking.second_to_last.id.to_s
      stringifytrue = Booking.second.id.to_s
      stringifytrue2 = Booking.eighth.id.to_s
      expect(ids.include?(stringify)).to eq(false)
      expect(ids.include?(stringify2)).to eq(false)
      expect(ids.include?(stringify3)).to eq(false)
      expect(ids.include?(stringifytrue)).to eq(true)
      expect(ids.include?(stringifytrue2)).to eq(true)
      expect(bookings[:data].count).to eq(7)
    end
  end

  describe 'sad paths' do
    it 'returns an empty array if no yards exist' do
      yard = create(:yard, id:1000)
      booking = create(:booking)
      create_list(:booking, 7)
      create_list(:booking, 2)
      get "/api/v1/yards/#{yard.id}/bookings"
      expect(response).to be_successful
      bookings = JSON.parse(response.body, symbolize_names:true)
      expect(bookings).to be_a(Hash)
      expect(bookings[:data]).to be_an(Hash)
      expect(bookings[:data].empty?).to eq(true)
    end

    it 'errors out when you pass a string as a param' do
      yard = create(:yard, id:1000)
      booking = create(:booking)
      create_list(:booking, 7)
      create_list(:booking, 2)
      get "/api/v1/yards/one/bookings"
      bookings = JSON.parse(response.body, symbolize_names:true)
      expect(bookings).to be_a(Hash)
      expect(bookings[:error]).to eq("String not accepted as id")
    end

    it 'returns something doesnt exist if it doesnt' do
      get "/api/v1/yards/22/bookings"
      expect(response.status).to eq(404)
      expect(response.body).to eq('Record not found')
    end

    it 'errors out when no param is passed ' do
      get "/api/v1/yards/bookings"
      expect(response.status).to eq(400)
    end
  end
end
