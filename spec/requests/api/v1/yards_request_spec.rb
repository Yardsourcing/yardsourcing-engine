require 'rails_helper'

RSpec.describe "Yards API Endpoints" do
  describe "Yard Details" do
    describe "Happy Path" do
      it "should return a json response with a specific yards details" do
        yard = create(:yard)

        get "/api/v1/yards/#{yard.id}"
        expect(response).to be_successful

        yard_details = JSON.parse(response.body, symbolize_names:true)

        expect(yard_details).to be_a(Hash)
        expect(yard_details[:data]).to be_a(Hash)
        expect(yard_details[:data][:attributes]).to be_a(Hash)
        expect(yard_details[:data][:attributes].count).to eq(13)
        expect(yard_details[:data][:attributes]).to have_key(:host_id)
        expect(yard_details[:data][:attributes]).to have_key(:name)
        expect(yard_details[:data][:attributes]).to have_key(:street_address)
        expect(yard_details[:data][:attributes]).to have_key(:city)
        expect(yard_details[:data][:attributes]).to have_key(:state)
        expect(yard_details[:data][:attributes]).to have_key(:zipcode)
        expect(yard_details[:data][:attributes]).to have_key(:price)
        expect(yard_details[:data][:attributes]).to have_key(:description)
        expect(yard_details[:data][:attributes]).to have_key(:payment)
        expect(yard_details[:data][:attributes]).to have_key(:availability)
        expect(yard_details[:data][:attributes]).to have_key(:photo_url_1)
        expect(yard_details[:data][:attributes]).to have_key(:photo_url_2)
        expect(yard_details[:data][:attributes]).to have_key(:photo_url_3)
      end
    end
    describe "Sad Path" do
      it "should return an empty array when there is no matching yard" do

        get "/api/v1/yards/1000000000"
        expect(response).to be_successful

        yard_details = JSON.parse(response.body, symbolize_names:true)
        expect(yard_details).to be_a(Hash)
        expect(yard_details[:data]).to be_an(Hash)
        expect(yard_details[:data].empty?).to eq(true)
      end
    end
    describe "Edge Case Path" do
      skip "should return an error when a string is passed in the URL" do

        get "/api/v1/yards/abcdefghijk"
        expect(response.status).to eq(400)

        yard_details = JSON.parse(response.body, symbolize_names:true)
        expect(yard_details).to be_a(Hash)
        expect(yard_details[:error]).to be_a(String)
      end
    end
  end
  describe "Yard Search" do
    describe "Happy Path" do
      skip "returns yard records that match the search criteria" do
        yard_1 = create(:yard, zipcode: 19125)
        yard_2 = create(:yard, zipcode: 19125)
        yard_3 = create(:yard, zipcode: 19125)
        yard_4 = create(:yard, zipcode: 19125)
        yard_5 = create(:yard, zipcode: 19125)

        pet_yard = create(:purpose, name: "Pet Yard")
        party_yard = create(:purpose, name: "Party Yard")
        hobby_yard = create(:purpose, name: "Hobby Yard")

        yard_1.purposes << pet_yard
        yard_2.purposes << pet_yard
        yard_3.purposes << pet_yard
        yard_5.purposes << pet_yard


        yard_1.purposes << hobby_yard
        yard_3.purposes << hobby_yard
        yard_5.purposes << hobby_yard
        yard_4.purposes << hobby_yard

        yard_2.purposes << party_yard
        yard_4.purposes << party_yard

        get "/api/v1/yards/yard_search?location=19125&purposes=pet+rental"
        expect(response).to be_successful
        yards = JSON.parse(response.body, symbolize_names:true)

        #structure tests
        expect(yards).to be_a(Hash)
        expect(yards[:data]).to be_an(Array)
        expect(yards[:data].first).to be_a(Hash)
        expect(yards[:data].first[:type]).to be_a(Yard)
        expect(yards[:data].first[:attributes]).to be_a(Hash)
        expect(yard_details[:data].first[:attributes].count).to eq(11)
        expect(yard_details[:data].first[:attributes]).to have_key(:host_id)
        expect(yard_details[:data].first[:attributes]).to have_key(:name)
        expect(yard_details[:data].first[:attributes]).to have_key(:street_address)
        expect(yard_details[:data].first[:attributes]).to have_key(:city)
        expect(yard_details[:data].first[:attributes]).to have_key(:state)
        expect(yard_details[:data].first[:attributes]).to have_key(:zipcode)
        expect(yard_details[:data].first[:attributes]).to have_key(:price)
        expect(yard_details[:data].first[:attributes]).to have_key(:description)
        expect(yard_details[:data].first[:attributes]).to have_key(:payment)
        expect(yard_details[:data].first[:attributes]).to have_key(:availability)
        expect(yard_details[:data].first[:attributes]).to have_key(:photo_url_1)
        expect(yard_details[:data].first[:attributes]).to have_key(:photo_url_2)
        expect(yard_details[:data].first[:attributes]).to have_key(:photo_url_3)

        #content tests
        expect(yard_details[:data][0][:attributes][:name]).to eq(yard_1.name)
        expect(yard_details[:data][1][:attributes][:name]).to eq(yard_2.name)
        expect(yard_details[:data][2][:attributes][:name]).to eq(yard_3.name)
        expect(yard_details[:data][3][:attributes][:name]).to eq(yard_5.name)

        get "/api/v1/yards/yard_search?location=19125&purposes=pet+rental&party+rental"
        expect(response).to be_successful
        yards = JSON.parse(response.body, symbolize_names:true)

        expect(yard_details[:data][0][:attributes][:name]).to eq(yard_2.name)

        get "/api/v1/yards/yard_search?location=19125&purposes=pet+rental&hobby+rental"
        expect(response).to be_successful
        yards = JSON.parse(response.body, symbolize_names:true)

        expect(yard_details[:data][0][:attributes][:name]).to eq(yard_1.name)
        expect(yard_details[:data][1][:attributes][:name]).to eq(yard_3.name)
        expect(yard_details[:data][2][:attributes][:name]).to eq(yard_5.name)
      end
    end
    describe "Sad Path" do
      skip "returns an empty array when no data matches the criteria" do
        get "/api/v1/yards/yard_search?location=13456&purposes=pet+rental&hobby+rental"
        expect(response).to require 'rails_helper'

        RSpec.desribe "Yards API Endpoints" do
          describe "Yard Details" do
            describe "Happy Path" do
              skip "should return a json response with a specific yards details" do
                yard = create(:yard)

                get "/api/v1/yards/#{yard.id}"
                expect(response).to be_successful

                yard_details = JSON.parse(response.body, symbolize_names:true)

                expect(yard_details).to be_a(Hash)
                expect(yard_details[:data]).to be_a(Hash)
                expect(yard_details[:data][:attributes]).to be_a(Hash)
                expect(yard_details[:data][:attributes].count).to eq(11)
                expect(yard_details[:data][:attributes]).to have_key(:host_id)
                expect(yard_details[:data][:attributes]).to have_key(:name)
                expect(yard_details[:data][:attributes]).to have_key(:street_address)
                expect(yard_details[:data][:attributes]).to have_key(:city)
                expect(yard_details[:data][:attributes]).to have_key(:state)
                expect(yard_details[:data][:attributes]).to have_key(:zipcode)
                expect(yard_details[:data][:attributes]).to have_key(:price)
                expect(yard_details[:data][:attributes]).to have_key(:description)
                expect(yard_details[:data][:attributes]).to have_key(:payment)
                expect(yard_details[:data][:attributes]).to have_key(:availability)
                expect(yard_details[:data][:attributes]).to have_key(:photo_url_1)
                expect(yard_details[:data][:attributes]).to have_key(:photo_url_2)
                expect(yard_details[:data][:attributes]).to have_key(:photo_url_3)
              end
            end
            describe "Sad Path" do
              skip "should return an empty array when there is no matching yard" do

                get "/api/v1/yards/1000000000"
                expect(response).to be_successful

                yard_details = JSON.parse(response.body, symbolize_names:true)
                expect(yard_details).to be_a(Hash)
                expect(yard_details[:data]).to be_an(Array)
                expect(yard_details[:data].empty?).to eq(true)
              end
            end
            describe "Edge Case Path" do
              skip "should return an error when a string is passed in the URL" do

                get "/api/v1/yards/abcdefghijk"
                expect(response.status).to eq(400)

                yard_details = JSON.parse(response.body, symbolize_names:true)
                expect(yard_details).to be_a(Hash)
                expect(yard_details[:error]).to be_a(String)
              end
            end
          end
          desribe "Yard Search" do
            describe "Happy Path" do
              skip "returns yard records that match the search criteria" do
                yard_1 = create(:yard, zipcode: 19125)
                yard_2 = create(:yard, zipcode: 19125)
                yard_3 = create(:yard, zipcode: 19125)
                yard_4 = create(:yard, zipcode: 19125)
                yard_5 = create(:yard, zipcode: 19125)

                pet_yard = create(:purpose, name: "Pet Yard")
                party_yard = create(:purpose, name: "Party Yard")
                hobby_yard = create(:purpose, name: "Hobby Yard")

                yard_1.purposes << pet_yard
                yard_2.purposes << pet_yard
                yard_3.purposes << pet_yard
                yard_5.purposes << pet_yard


                yard_1.purposes << hobby_yard
                yard_3.purposes << hobby_yard
                yard_5.purposes << hobby_yard
                yard_4.purposes << hobby_yard

                yard_2.purposes << party_yard
                yard_4.purposes << party_yard

                get "/api/v1/yards/yard_search?location=19125&purposes=pet+rental"
                expect(response).to be_successful
                yards = JSON.parse(response.body, symbolize_names:true)

                #structure tests
                expect(yards).to be_a(Hash)
                expect(yards[:data]).to be_an(Array)
                expect(yards[:data].first).to be_a(Hash)
                expect(yards[:data].first[:type]).to be_a(Yard)
                expect(yards[:data].first[:attributes]).to be_a(Hash)
                expect(yard_details[:data].first[:attributes].count).to eq(11)
                expect(yard_details[:data].first[:attributes]).to have_key(:host_id)
                expect(yard_details[:data].first[:attributes]).to have_key(:name)
                expect(yard_details[:data].first[:attributes]).to have_key(:street_address)
                expect(yard_details[:data].first[:attributes]).to have_key(:city)
                expect(yard_details[:data].first[:attributes]).to have_key(:state)
                expect(yard_details[:data].first[:attributes]).to have_key(:zipcode)
                expect(yard_details[:data].first[:attributes]).to have_key(:price)
                expect(yard_details[:data].first[:attributes]).to have_key(:description)
                expect(yard_details[:data].first[:attributes]).to have_key(:payment)
                expect(yard_details[:data].first[:attributes]).to have_key(:availability)
                expect(yard_details[:data].first[:attributes]).to have_key(:photo_url_1)
                expect(yard_details[:data].first[:attributes]).to have_key(:photo_url_2)
                expect(yard_details[:data].first[:attributes]).to have_key(:photo_url_3)

                #content tests
                expect(yard_details[:data][0][:attributes][:name]).to eq(yard_1.name)
                expect(yard_details[:data][1][:attributes][:name]).to eq(yard_2.name)
                expect(yard_details[:data][2][:attributes][:name]).to eq(yard_3.name)
                expect(yard_details[:data][3][:attributes][:name]).to eq(yard_5.name)

                get "/api/v1/yards/yard_search?location=19125&purposes=pet+rental&party+rental"
                expect(response).to be_successful
                yards = JSON.parse(response.body, symbolize_names:true)

                expect(yard_details[:data][0][:attributes][:name]).to eq(yard_2.name)

                get "/api/v1/yards/yard_search?location=19125&purposes=pet+rental&hobby+rental"
                expect(response).to be_successful
                yards = JSON.parse(response.body, symbolize_names:true)

                expect(yard_details[:data][0][:attributes][:name]).to eq(yard_1.name)
                expect(yard_details[:data][1][:attributes][:name]).to eq(yard_3.name)
                expect(yard_details[:data][2][:attributes][:name]).to eq(yard_5.name)
              end
            end
            describe "Sad Path" do
              skip "returns an empty array when no data matches the criteria" do
                get "/api/v1/yards/yard_search?location=13456&purposes=pet+rental&hobby+rental"
                expect(response).to be_successful

                yard_details = JSON.parse(response.body, symbolize_names:true)
                expect(yard_details).to be_a(Hash)
                expect(yard_details[:data]).to be_an(Array)
                expect(yard_details[:data].empty?).to eq(true)
              end
            end
          end
        end
be_successful

        yard_details = JSON.parse(response.body, symbolize_names:true)
        expect(yard_details).to be_a(Hash)
        expect(yard_details[:data]).to be_an(Array)
        expect(yard_details[:data].empty?).to eq(true)
      end
    end
  end
end
