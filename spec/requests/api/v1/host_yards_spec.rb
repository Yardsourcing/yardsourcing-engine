require 'rails_helper'

RSpec.describe 'Host Yards' do
  describe "Happy Path" do
    it "should return a json response with a host's specific yards details and purposes" do
      purposes = create_list(:purpose, 3)
      host_id = 1
      host_id2 = 2
      yard = create(:yard, host_id: host_id)
      yard.purposes << [purposes]
      yard2 = create(:yard, host_id: host_id)
      yard2.purposes << [purposes]
      yard3 = create(:yard, host_id: host_id2)
      yard3.purposes << [purposes]

      get "/api/v1/hosts/#{host_id}/yards"
      expect(response).to be_successful

      yard_details = JSON.parse(response.body, symbolize_names:true)

      expect(yard_details).to be_a(Hash)
      expect(yard_details[:data]).to be_a(Array)

      expect(yard_details[:data].count).to eq(2)
      first_yard = yard_details[:data].first
      expect(first_yard[:attributes]).to be_a(Hash)
      expect(first_yard[:attributes].count).to eq(14)
      expect(first_yard[:attributes]).to have_key(:host_id)
      expect(first_yard[:attributes][:host_id]).to be_a(Integer)
      expect(first_yard[:attributes]).to have_key(:name)
      expect(first_yard[:attributes][:name]).to be_a(String)
      expect(first_yard[:attributes]).to have_key(:street_address)
      expect(first_yard[:attributes][:street_address]).to be_a(String)
      expect(first_yard[:attributes]).to have_key(:city)
      expect(first_yard[:attributes][:city]).to be_a(String)
      expect(first_yard[:attributes]).to have_key(:state)
      expect(first_yard[:attributes][:state]).to be_a(String)
      expect(first_yard[:attributes]).to have_key(:zipcode)
      expect(first_yard[:attributes][:zipcode]).to be_a(String)
      expect(first_yard[:attributes]).to have_key(:price)
      expect(first_yard[:attributes][:price]).to be_a(Float)
      expect(first_yard[:attributes]).to have_key(:description)
      expect(first_yard[:attributes][:description]).to be_a(String)
      expect(first_yard[:attributes]).to have_key(:payment)
      expect(first_yard[:attributes][:payment]).to be_a(String)
      expect(first_yard[:attributes]).to have_key(:availability)
      expect(first_yard[:attributes][:availability]).to be_a(String)
      expect(first_yard[:attributes]).to have_key(:photo_url_1)
      expect(first_yard[:attributes][:photo_url_1]).to be_a(String)
      expect(first_yard[:attributes]).to have_key(:photo_url_2)
      expect(first_yard[:attributes]).to have_key(:photo_url_3)
      expect(first_yard[:attributes]).to have_key(:purposes)
      expect(first_yard[:attributes]).to have_key(:purposes)
      expect(first_yard[:attributes][:purposes][:data].count).to eq(3)
      expect(first_yard[:attributes][:purposes]).to be_a(Hash)
      expect(first_yard[:attributes][:purposes][:data]).to be_an(Array)
      expect(first_yard[:attributes][:purposes][:data][0]).to be_a(Hash)
      expect(first_yard[:attributes][:purposes][:data][0][:attributes]).to be_a(Hash)
      expect(first_yard[:attributes][:purposes][:data][0][:attributes]).to have_key(:name)
      expect(first_yard[:attributes][:purposes][:data][0][:attributes][:name]).to be_a(String)
      expect(first_yard[:attributes][:purposes][:data][0][:attributes][:name]).to eq("#{purposes.first.name}")
      expect(first_yard[:attributes][:purposes][:data][-1][:attributes][:name]).to eq("#{purposes.last.name}")
    end
  end
  describe "Sad Path" do
    it "should return an empty array when the host has no yards" do

      get "/api/v1/hosts/1/yards"
      expect(response).to be_successful

      yard_details = JSON.parse(response.body, symbolize_names:true)
      expect(yard_details).to be_a(Hash)
      expect(yard_details[:data]).to be_an(Array)
      expect(yard_details[:data].empty?).to eq(true)
    end
    it "should return an empty array when the host ID doesn't exist" do

      get "/api/v1/hosts/100000/yards"
      expect(response).to be_successful

      yard_details = JSON.parse(response.body, symbolize_names:true)
      expect(yard_details).to be_a(Hash)
      expect(yard_details[:data]).to be_an(Array)
      expect(yard_details[:data].empty?).to eq(true)
    end
  end
  describe "Edge Case Path" do
    it "should return an error when a string is passed in the URL" do

      get "/api/v1/hosts/asdfsdfsdfsfd/yards"
      expect(response.status).to eq(400)

      yard_details = JSON.parse(response.body, symbolize_names:true)
      expect(yard_details).to be_a(Hash)
      expect(yard_details[:error]).to be_a(String)
    end
  end
end
