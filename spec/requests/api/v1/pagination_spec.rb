require 'rails_helper'
RSpec.describe 'Pagination' do
  before :each do
    @yard = create(:yard, id: 1)
    create_list(:booking, 21, yard: @yard)
  end

  describe 'happy path' do
    it 'returns only 20 bookings by renter' do
      get '/api/v1/renters/1/bookings'

      expect(response).to be_successful

      bookings = JSON.parse(response.body, symbolize_names:true)

      expect(bookings).to be_a(Hash)
      expect(bookings[:data]).to be_an(Array)
      expect(bookings[:data].count).to eq(20)
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
      end
    end

    it 'returns 20 bookings by renter on page 2' do
      get '/api/v1/renters/1/bookings?page=2'

      expect(response).to be_successful

      bookings = JSON.parse(response.body, symbolize_names:true)

      expect(bookings).to be_a(Hash)
      expect(bookings[:data]).to be_an(Array)
      expect(bookings[:data].count).to eq(1)
      expect(bookings[:data].first).to be_a(Hash)
      expect(bookings[:data].first[:type]).to eq('booking')
    end

    it 'returns 20 bookings by yard' do
      get '/api/v1/yards/1/bookings'

      expect(response).to be_successful

      bookings = JSON.parse(response.body, symbolize_names:true)

      expect(bookings).to be_a(Hash)
      expect(bookings[:data]).to be_an(Array)
      expect(bookings[:data].count).to eq(20)
      expect(bookings[:data].first).to be_a(Hash)
      expect(bookings[:data].first[:type]).to eq('booking')
    end

    it 'returns 20 yards by zipcode' do
      create_list(:yard, 21, zipcode: '19125')

      get "/api/v1/yards/yard_search?location=19125"
      expect(response).to be_successful
      yards = JSON.parse(response.body, symbolize_names:true)

      expect(yards).to be_a(Hash)
      expect(yards[:data]).to be_an(Array)
      expect(yards[:data].first).to be_a(Hash)
      expect(yards[:data].first[:type]).to eq('yard')
      expect(yards[:data].count).to eq(20)
    end

    it 'returns 20 yards by zipcode and purpose' do
      @pet_yard = create(:purpose, name: "Pet Yard")
      yards = create_list(:yard, 21, zipcode: '19125')

      yards.each do |yard|
        create(:yard_purpose, yard: yard, purpose: @pet_yard)
      end

      get "/api/v1/yards/yard_search?location=19125&purposes[]=pet+yard"
      expect(response).to be_successful
      yards = JSON.parse(response.body, symbolize_names:true)

      expect(yards).to be_a(Hash)
      expect(yards[:data]).to be_an(Array)
      expect(yards[:data].first).to be_a(Hash)
      expect(yards[:data].first[:type]).to eq('yard')
      expect(yards[:data].count).to eq(20)
    end

    it 'only shows 20 purposes' do
      create_list(:purpose, 21)
      get "/api/v1/purposes"

      expect(response).to be_successful
      purposes = JSON.parse(response.body, symbolize_names:true)

      expect(purposes).to be_a(Hash)
      expect(purposes[:data]).to be_an(Array)
      expect(purposes[:data].count).to eq(20)
      expect(purposes[:data].first).to be_a(Hash)
      expect(purposes[:data].first[:type]).to eq('purpose')
    end

    it 'only shows 20 yards by host' do
      yards = create_list(:yard, 21)

      get "/api/v1/hosts/1/yards"
      expect(response).to be_successful

      yard_details = JSON.parse(response.body, symbolize_names:true)

      expect(yard_details).to be_a(Hash)
      expect(yard_details[:data]).to be_a(Array)
      expect(yard_details[:data].count).to eq(20)
      expect(yard_details[:data].first).to be_a(Hash)
      expect(yard_details[:data].first[:type]).to eq('yard')
    end

    it 'only shows 20 bookings by host' do
      get "/api/v1/hosts/1/bookings"
      expect(response).to be_successful

      bookings = JSON.parse(response.body, symbolize_names:true)

      expect(bookings).to be_a(Hash)
      expect(bookings[:data]).to be_a(Array)
      expect(bookings[:data].count).to eq(20)
      expect(bookings[:data].first).to be_a(Hash)
      expect(bookings[:data].first[:type]).to eq('booking')
    end

    it 'only shows 20 bookings by host and status' do
      get "/api/v1/hosts/1/bookings?status=pending"
      expect(response).to be_successful

      bookings = JSON.parse(response.body, symbolize_names:true)

      expect(bookings).to be_a(Hash)
      expect(bookings[:data]).to be_a(Array)
      expect(bookings[:data].count).to eq(20)
      expect(bookings[:data].first).to be_a(Hash)
      expect(bookings[:data].first[:type]).to eq('booking')
    end

    it 'defaults to 20 when passing a string in page param' do
      yards = create_list(:yard, 21)

      get "/api/v1/hosts/1/yards?page=number"

      yard_details = JSON.parse(response.body, symbolize_names:true)

      expect(yard_details).to be_a(Hash)
      expect(yard_details[:data]).to be_a(Array)
      expect(yard_details[:data].count).to eq(20)
      expect(yard_details[:data].first).to be_a(Hash)
      expect(yard_details[:data].first[:type]).to eq('yard')
    end

    it 'defaults to 20 when nothing is passed in page param' do
      yards = create_list(:yard, 21)

      get "/api/v1/hosts/1/yards?page="

      yard_details = JSON.parse(response.body, symbolize_names:true)
      expect(yard_details).to be_a(Hash)
      expect(yard_details[:data]).to be_a(Array)
      expect(yard_details[:data].count).to eq(20)
      expect(yard_details[:data].first).to be_a(Hash)
      expect(yard_details[:data].first[:type]).to eq('yard')
    end
  end
end
