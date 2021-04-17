require 'rails_helper'

RSpec.describe "Yard Search" do
  describe "Happy Path" do
    it "returns yard records that match the zipcode criteria" do
      yard_1 = create(:yard, zipcode: '19125')
      yard_2 = create(:yard, zipcode: '19125')
      yard_3 = create(:yard, zipcode: '19125')
      yard_4 = create(:yard, zipcode: '54678')
      yard_5 = create(:yard, zipcode: '11122')

      get "/api/v1/yards/yard_search?location=19125"
      expect(response).to be_successful
      yards = JSON.parse(response.body, symbolize_names:true)

      expect(yards).to be_a(Hash)
      expect(yards[:data]).to be_an(Array)
      expect(yards[:data].first).to be_a(Hash)
      expect(yards[:data].first[:type]).to eq('yard')
      expect(yards[:data].count).to eq(3)
      expect(yards[:data].first[:id]).to eq(yard_1.id.to_s)
      expect(yards[:data].last[:id]).to eq(yard_3.id.to_s)

      yard_ids = yards[:data].map do |yard|
        yard[:id].to_i
      end
      expect(yard_ids.include?(yard_4.id)).to eq(false)
      expect(yard_ids.include?(yard_5.id)).to eq(false)
    end

    it "returns yard records that match the search criteria" do
      yard_1 = create(:yard, zipcode: '19125')
      yard_2 = create(:yard, zipcode: '19125')
      yard_3 = create(:yard, zipcode: '19125')
      yard_4 = create(:yard, zipcode: '54678')
      yard_5 = create(:yard, zipcode: '11122')

      pet_yard = create(:purpose, name: "Pet Yard")
      party_yard = create(:purpose, name: "Party Yard")
      hobby_yard = create(:purpose, name: "Hobby Yard")

      yard_1.purposes << pet_yard
      yard_3.purposes << pet_yard
      yard_5.purposes << pet_yard


      yard_1.purposes << hobby_yard
      yard_3.purposes << hobby_yard
      yard_5.purposes << hobby_yard
      yard_4.purposes << hobby_yard

      yard_2.purposes << party_yard
      yard_4.purposes << party_yard

      get "/api/v1/yards/yard_search?location=19125&purposes[]=pet+yard&purposes[]=hobby+yard"
      expect(response).to be_successful
      yards = JSON.parse(response.body, symbolize_names:true)

      expect(yards).to be_a(Hash)
      expect(yards[:data]).to be_an(Array)
      expect(yards[:data].first).to be_a(Hash)
      expect(yards[:data].first[:id]).to eq(yard_1.id.to_s)
      expect(yards[:data].last[:id]).to eq(yard_3.id.to_s)

      yard_ids = yards[:data].map do |yard|
        yard[:id].to_i
      end
      expect(yard_ids.include?(yard_2.id)).to eq(false)
      expect(yard_ids.include?(yard_4.id)).to eq(false)
      expect(yard_ids.include?(yard_5.id)).to eq(false)
    end
  end

  describe "Sad Path" do
    it "returns an empty array when no zipcode matches the criteria" do
      get "/api/v1/yards/yard_search?location=13456"
      # get "/api/v1/yards/yard_search?location=13456&purposes=pet+rental&hobby+rental"
      expect(response).to be_successful

      yard_details = JSON.parse(response.body, symbolize_names:true)
      expect(yard_details).to be_a(Hash)
      expect(yard_details[:data]).to be_an(Array)
      expect(yard_details[:data].empty?).to eq(true)
    end
  end

  describe 'Edge Cases' do
    it "returns an error when the zipcode contains alpha characters" do
      get "/api/v1/yards/yard_search?location=134A6"

      expect(response).to_not be_successful
      yard_details = JSON.parse(response.body, symbolize_names:true)

      expect(response).to have_http_status(:bad_request)
      expect(yard_details[:error]).to be_a(String)
      expect(yard_details[:error]).to eq("Invalid zipcode")
    end

    it "returns an error when the zipcode is not 5 numeric characters" do
      get "/api/v1/yards/yard_search?location=1346"

      expect(response).to_not be_successful
      yard_details = JSON.parse(response.body, symbolize_names:true)

      expect(response).to have_http_status(:bad_request)
      expect(yard_details[:error]).to be_a(String)
      expect(yard_details[:error]).to eq("Invalid zipcode")
    end
  end
end
