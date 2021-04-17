require 'rails_helper'

RSpec.describe 'Yard API SPEC'do
  describe 'happy path' do
    it 'returns specific bookings by a yard id' do
      yard = create(:yard)
      booking = create(:booking)
      create_list(:booking, 10, yard_id: yard.id)
      get '/api/v1/yards/yard_id/bookings'
      expect(response).to be_successful
      booking = JSON.parse(response.body, symbolize_names:true)
      require "pry"; binding.pry
    end
  end
end
