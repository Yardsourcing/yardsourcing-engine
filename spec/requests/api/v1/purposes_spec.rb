require 'rails_helper'

RSpec.describe "Purpose API SPEC" do
  describe 'happy path' do
    it 'returns an index of purposes including names in json' do

      create_list(:purpose, 3)
      get "/api/v1/purposes"
      expect(response).to be_successful
    end

    it 'returns the expected datatype for purposes in json' do
      purpose_list = create_list(:purpose, 3)
      get "/api/v1/purposes"
      purposes = JSON.parse(response.body, symbolize_names:true)
      expect(purposes).to be_a(Hash)
      expect(purposes[:data]).to be_an(Array)
      expect(purposes[:data].count).to eq(3)
      expect(purposes[:data].first).to be_a(Hash)
      expect(purposes[:data].first[:id]).to be_a(String)
      expect(purposes[:data].first[:id].to_i).to eq(purpose_list.first.id)
      expect(purposes[:data].second[:id].to_i).to eq(purpose_list.second.id)
      expect(purposes[:data].third[:id].to_i).to eq(purpose_list.third.id)
      expect(purposes[:data].first[:attributes]).to be_a(Hash)
      expect(purposes[:data].first[:attributes].count).to eq(1)
      expect(purposes[:data].first[:attributes]).to have_key(:name)
      expect(purposes[:data].first[:attributes][:name]).to eq(purpose_list.first.name)
      expect(purposes[:data].second[:attributes][:name]).to eq(purpose_list.second.name)
      expect(purposes[:data].third[:attributes][:name]).to eq(purpose_list.third.name)
    end
  end

  describe 'sad path ' do
    it 'if we had a terrible unforseen issue and our beautiful three purposes were destroyed for some reason' do
      get "/api/v1/purposes"
      expect(response).to be_successful
      sad_day = JSON.parse(response.body, symbolize_names:true)
      expect(sad_day).to be_a(Hash)
      expect(sad_day[:data]).to be_a(Hash)
      expect(sad_day[:data].empty?).to eq(true)
    end
  end
end
