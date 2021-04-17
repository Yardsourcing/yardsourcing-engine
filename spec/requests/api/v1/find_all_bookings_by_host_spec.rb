require 'rails_helper'
RSpec.describe 'All Bookings by Renter API' do
  before :each do
    yard = create(:yard, host_id: 1)
    create_list(:booking, 2, status: 'pending', yard_id: yard.id)
    create_list(:booking, 2, status: 'rejected', yard_id: yard.id)
    create_list(:booking, 2, status: 'approved', yard_id: yard.id)
  end

  describe 'happy path' do
    it 'returns all bookings' do
      get "/api/v1/hosts/1/bookings"

      expect(response).to be_successful

      bookings = JSON.parse(response.body, symbolize_names:true)

      expect(bookings).to be_a(Hash)
      expect(bookings[:data]).to be_an(Array)
      expect(bookings[:data].count).to eq(6)
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
  end

  # describe 'sad path' do
  #   it 'returns an empty array if no bookings exist' do
  #     booking = create(:booking, renter_id: 2)
  #     create_list(:booking, 7, renter_id: 2)
  #     create_list(:booking, 2, renter_id: 2)
  #
  #     get "/api/v1/hosts/3/bookings"
  #
  #     expect(response).to be_successful
  #     bookings = JSON.parse(response.body, symbolize_names:true)
  #     expect(bookings).to be_a(Hash)
  #     expect(bookings[:data]).to be_a(Hash)
  #     expect(bookings[:data].empty?).to eq(true)
  #   end
  #
  #   it 'returns an error if string for renter_id' do
  #     booking = create(:booking, renter_id: 2)
  #     create_list(:booking, 7, renter_id: 2)
  #     create_list(:booking, 2, renter_id: 2)
  #
  #     get "/api/v1/hosts/three/bookings"
  #
  #     bookings = JSON.parse(response.body, symbolize_names:true)
  #     expect(bookings).to be_a(Hash)
  #     expect(bookings[:error]).to eq("String not accepted as id")
  #   end
  # end
end
