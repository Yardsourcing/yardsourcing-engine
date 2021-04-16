require 'rails_helper'

RSpec.describe "Yards API Endpoints" do
  describe "Yard Details" do
    describe "Happy Path" do
      it "should return a json response with a specific yards details and purposes" do
        purposes = create_list(:purpose, 3)
        yard = create(:yard)
        yard.purposes << [purposes]
        get "/api/v1/yards/#{yard.id}"
        expect(response).to be_successful

        yard_details = JSON.parse(response.body, symbolize_names:true)

        expect(yard_details).to be_a(Hash)
        expect(yard_details[:data]).to be_a(Hash)
        expect(yard_details[:data][:attributes]).to be_a(Hash)
        expect(yard_details[:data][:attributes].count).to eq(14)
        expect(yard_details[:data][:attributes]).to have_key(:host_id)
        expect(yard_details[:data][:attributes][:host_id]).to be_a(Integer)
        expect(yard_details[:data][:attributes]).to have_key(:name)
        expect(yard_details[:data][:attributes][:name]).to be_a(String)
        expect(yard_details[:data][:attributes]).to have_key(:street_address)
        expect(yard_details[:data][:attributes][:street_address]).to be_a(String)
        expect(yard_details[:data][:attributes]).to have_key(:city)
        expect(yard_details[:data][:attributes][:city]).to be_a(String)
        expect(yard_details[:data][:attributes]).to have_key(:state)
        expect(yard_details[:data][:attributes][:state]).to be_a(String)
        expect(yard_details[:data][:attributes]).to have_key(:zipcode)
        expect(yard_details[:data][:attributes][:zipcode]).to be_a(String)
        expect(yard_details[:data][:attributes]).to have_key(:price)
        expect(yard_details[:data][:attributes][:price]).to be_a(Float)
        expect(yard_details[:data][:attributes]).to have_key(:description)
        expect(yard_details[:data][:attributes][:description]).to be_a(String)
        expect(yard_details[:data][:attributes]).to have_key(:payment)
        expect(yard_details[:data][:attributes][:payment]).to be_a(String)
        expect(yard_details[:data][:attributes]).to have_key(:availability)
        expect(yard_details[:data][:attributes][:availability]).to be_a(String)
        expect(yard_details[:data][:attributes]).to have_key(:photo_url_1)
        expect(yard_details[:data][:attributes][:photo_url_1]).to be_a(String)
        expect(yard_details[:data][:attributes]).to have_key(:photo_url_2)
        expect(yard_details[:data][:attributes]).to have_key(:photo_url_3)
        expect(yard_details[:data][:attributes]).to have_key(:purposes)
        expect(yard_details[:data][:attributes]).to have_key(:purposes)
        expect(yard_details[:data][:attributes][:purposes][:data].count).to eq(3)
        expect(yard_details[:data][:attributes][:purposes]).to be_a(Hash)
        expect(yard_details[:data][:attributes][:purposes][:data]).to be_an(Array)
        expect(yard_details[:data][:attributes][:purposes][:data][0]).to be_a(Hash)
        expect(yard_details[:data][:attributes][:purposes][:data][0][:attributes]).to be_a(Hash)
        expect(yard_details[:data][:attributes][:purposes][:data][0][:attributes]).to have_key(:name)
        expect(yard_details[:data][:attributes][:purposes][:data][0][:attributes][:name]).to be_a(String)
        expect(yard_details[:data][:attributes][:purposes][:data][0][:attributes][:name]).to eq("#{purposes.first.name}")
        expect(yard_details[:data][:attributes][:purposes][:data][-1][:attributes][:name]).to eq("#{purposes.last.name}")
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
      it "should return an error when a string is passed in the URL" do

        get "/api/v1/yards/abcdefghijk"
        expect(response.status).to eq(400)

        yard_details = JSON.parse(response.body, symbolize_names:true)
        expect(yard_details).to be_a(Hash)
        expect(yard_details[:error]).to be_a(String)
      end
    end
  end
  describe "CRUD Functionality" do
    it "can create a new yard" do
      purposes = create_list(:purpose, 3)
      yard_params = ({
                      id: 1,
                      host_id: 1,
                      name: 'yard',
                      street_address: '123 Fake St.',
                      city: 'Denver',
                      state: 'CO',
                      zipcode: '12345',
                      price: 20.00,
                      description: 'description',
                      availability: 'availability',
                      payment: 'venmo',
                      photo_url_1: 'url1',
                      photo_url_2: 'url2',
                      photo_url_3: 'url3',
                      purposes: [purposes.first.id, purposes.last.id]
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/yards", headers: headers, params: JSON.generate(yard: yard_params)
      created_yard = Yard.last

      expect(response).to be_successful
      expect(created_yard.host_id).to eq(yard_params[:host_id])
      expect(created_yard.name).to eq(yard_params[:name])
      expect(created_yard.street_address).to eq(yard_params[:street_address])
      expect(created_yard.city).to eq(yard_params[:city])
      expect(created_yard.state).to eq(yard_params[:state])
      expect(created_yard.zipcode).to eq(yard_params[:zipcode])
      expect(created_yard.price).to eq(yard_params[:price])
      expect(created_yard.description).to eq(yard_params[:description])
      expect(created_yard.availability).to eq(yard_params[:availability])
      expect(created_yard.photo_url_1).to eq(yard_params[:photo_url_1])
      expect(created_yard.photo_url_2).to eq(yard_params[:photo_url_2])
      expect(created_yard.photo_url_3).to eq(yard_params[:photo_url_3])
      expect(created_yard.yard_purposes.first.purpose_id).to eq(purposes.first.id)
      expect(created_yard.yard_purposes.last.purpose_id).to eq(purposes.last.id)
      expect(created_yard.yard_purposes.include?(purposes.second.id)).to eq(false)

      expect(response).to have_http_status(:created)
      yard = JSON.parse(response.body, symbolize_names: true)
    end

    it "Won't create a new yard with missing information" do
      purposes = create_list(:purpose, 3)
      yard_params = ({
                      id: 1,
                      street_address: "123 Fake St.",
                      city: "Denver",
                      state: "CO",
                      zipcode: '12345',
                      price: 20.00,
                      description: 'description',
                      availability: 'availability',
                      payment: 'venmo',
                      photo_url_1: 'url1',
                      photo_url_2: 'url2',
                      photo_url_3: 'url3',
                      purposes: [purposes.first.id, purposes.last.id]
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/yards", headers: headers, params: JSON.generate(yard: yard_params)

      expect(response).to have_http_status(:not_found)
    end

    it "Won't create a new yard when there are no purposes" do
      yard_params = ({
                      id: 1,
                      host_id: 1,
                      name: 'yard',
                      street_address: "123 Fake St.",
                      city: "Denver",
                      state: "CO",
                      zipcode: '12345',
                      price: 20.00,
                      description: 'description',
                      availability: 'availability',
                      payment: 'venmo',
                      photo_url_1: 'url1',
                      photo_url_2: 'url2',
                      photo_url_3: 'url3'
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/yards", headers: headers, params: JSON.generate(yard: yard_params)
      returned_json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_acceptable)
      expect(returned_json[:error]).to be_a(String)
      expect(returned_json[:error]).to eq("You must select at least one purpose")
    end

    it "can update an existing yard and remove a purpose when necessary" do
      purposes = create_list(:purpose, 3)
      yard = create(:yard)
      yard.purposes << [purposes]
      id = yard.id
      previous_name = Yard.last.name
      yard_params = { name: "New Name", purposes: [purposes.first.id, purposes.last.id] }
      headers = {"CONTENT_TYPE" => "application/json"}
      expect(yard.purposes.count).to eq(3)

      patch "/api/v1/yards/#{id}", headers: headers, params: JSON.generate({yard: yard_params})

      yard = Yard.find_by(id: id)
      expect(response).to be_successful
      expect(yard.name).to_not eq(previous_name)
      expect(yard.name).to eq(yard_params[:name])
      expect(yard.purposes.count).to eq(2)
    end

    it "can update an existing yard and create a purpose that doesn't exist" do
      purposes = create_list(:purpose, 3)
      yard = create(:yard)
      yard.purposes << [purposes.first, purposes.second]
      id = yard.id
      previous_name = Yard.last.name
      yard_params = { name: "New Name", purposes: purposes.map(&:id) }
      headers = {"CONTENT_TYPE" => "application/json"}
      expect(yard.purposes.count).to eq(2)

      patch "/api/v1/yards/#{id}", headers: headers, params: JSON.generate({yard: yard_params})

      yard = Yard.find_by(id: id)
      expect(response).to be_successful
      expect(yard.name).to_not eq(previous_name)
      expect(yard.name).to eq(yard_params[:name])
      expect(yard.purposes.count).to eq(3)
    end

    it "can't update an existing yard when all purposes have been removed" do
      purposes = create_list(:purpose, 3)
      yard = create(:yard)
      yard.purposes << [purposes]
      id = yard.id
      previous_name = Yard.last.name
      yard_params = { name: "New Name"}
      headers = {"CONTENT_TYPE" => "application/json"}
      expect(yard.purposes.count).to eq(3)

      patch "/api/v1/yards/#{id}", headers: headers, params: JSON.generate({yard: yard_params})
      yard = Yard.find_by(id: id)
      returned_json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:not_acceptable)
      expect(returned_json[:error]).to be_a(String)
      expect(returned_json[:error]).to eq("You must select at least one purpose")
      expect(yard.name).to eq(previous_name)
      expect(yard.purposes.count).to eq(3)

    end

    it "can't update an yard that doesn't exist" do
      yard_params = { name: "New Name" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/yards/#{99999999}", headers: headers, params: JSON.generate({yard: yard_params})
      expect(response).to_not be_successful
      expect(response).to have_http_status(:not_found)
    end

    it "can't update an existing yard with a bad ID" do
      id = 1000000
      yard_params = ({
                      id: id,
                      street_address: "123 Fake St.",
                      city: "Denver",
                      state: "CO",
                      zipcode: '12345',
                      price: 20.00,
                      description: 'description',
                      availability: 'availability',
                      payment: 'venmo',
                      photo_url_1: 'url1',
                      photo_url_2: 'url2',
                      photo_url_3: 'url3'
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/yards/#{id}", headers: headers, params: JSON.generate({yard: yard_params})

      expect(response).to_not be_successful
      expect(response.code).to eq("404")
    end

    it "can update the purposes on an existing yard" do
      YardPurpose.destroy_all
      purposes = create_list(:purpose, 3)
      yard_params = ({
                      id: 1,
                      host_id: 1,
                      name: 'yard',
                      street_address: '123 Fake St.',
                      city: 'Denver',
                      state: 'CO',
                      zipcode: '12345',
                      price: 20.00,
                      description: 'description',
                      availability: 'availability',
                      payment: 'venmo',
                      photo_url_1: 'url1',
                      photo_url_2: 'url2',
                      photo_url_3: 'url3'
                    })
      yard = Yard.create!(yard_params)
      create(:yard_purpose, yard: yard, purpose: purposes.first)

      headers = {"CONTENT_TYPE" => "application/json"}
      new_yard_params = ({
                      purposes: [purposes.first.id,purposes.second.id, purposes.last.id]
                    })
      patch "/api/v1/yards/#{yard.id}", headers: headers, params: JSON.generate({yard: new_yard_params})
      yard = Yard.find_by(id: yard.id)
      expect(response).to be_successful

      expect(yard.purposes.find(purposes.first.id)).to eq(purposes.first)
      expect(yard.purposes.find(purposes.second.id)).to eq(purposes.second)
      expect(yard.purposes.find(purposes.last.id)).to eq(purposes.last)
    end

    it "can delete the purposes on an existing yard that are no longer checked" do
      YardPurpose.destroy_all
      purposes = create_list(:purpose, 3)
      yard_params = ({
                      id: 1,
                      host_id: 1,
                      name: 'yard',
                      street_address: '123 Fake St.',
                      city: 'Denver',
                      state: 'CO',
                      zipcode: '12345',
                      price: 20.00,
                      description: 'description',
                      availability: 'availability',
                      payment: 'venmo',
                      photo_url_1: 'url1',
                      photo_url_2: 'url2',
                      photo_url_3: 'url3'
                    })
      yard = Yard.create!(yard_params)
      create(:yard_purpose, yard: yard, purpose: purposes.first)

      headers = {"CONTENT_TYPE" => "application/json"}
      new_yard_params = ({
                      purposes: [purposes.second.id, purposes.last.id]
                    })
      patch "/api/v1/yards/#{yard.id}", headers: headers, params: JSON.generate({yard: new_yard_params})
      yard = Yard.find_by(id: yard.id)
      expect(response).to be_successful

      expect(yard.purposes.where(id: purposes.first.id)).to eq([])
      expect(yard.purposes.find(purposes.second.id)).to eq(purposes.second)
      expect(yard.purposes.find(purposes.last.id)).to eq(purposes.last)
    end

    it "can destroy an yard" do
      yard = create(:yard)

      expect(Yard.count).to eq(1)

      delete "/api/v1/yards/#{yard.id}"

      expect(response).to be_successful
      expect(Yard.count).to eq(0)
      expect{Yard.find(yard.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  describe "Yard Search" do
    describe "Happy Path" do
      skip "returns yard records that match the search criteria" do
        yard_1 = create(:yard, zipcode: '19125')
        yard_2 = create(:yard, zipcode: '19125')
        yard_3 = create(:yard, zipcode: '19125')
        yard_4 = create(:yard, zipcode: '19125')
        yard_5 = create(:yard, zipcode: '19125')

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
