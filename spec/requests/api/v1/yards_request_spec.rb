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
                      email: "host_eamil@domain.com",
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

      post "/api/v1/yards", headers: headers, params: JSON.generate(yard_params)
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

      post "/api/v1/yards", headers: headers, params: JSON.generate(yard_params)
      error = JSON.parse(response.body, symbolize_names:true)
      error_message = "Validation failed: Host can't be blank, Host is not a number, Name can't be blank, Email can't be blank, Email is invalid"

      expect(response).to have_http_status(:not_found)
      expect(error).to have_key(:error)
      expect(error[:error]).to eq("#{error_message}")
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

      post "/api/v1/yards", headers: headers, params: JSON.generate(yard_params)
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

      patch "/api/v1/yards/#{id}", headers: headers, params: JSON.generate(yard_params)

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

      patch "/api/v1/yards/#{id}", headers: headers, params: JSON.generate(yard_params)

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

      patch "/api/v1/yards/#{id}", headers: headers, params: JSON.generate(yard_params)
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

      patch "/api/v1/yards/#{99999999}", headers: headers, params: JSON.generate(yard_params)
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

      patch "/api/v1/yards/#{id}", headers: headers, params: JSON.generate(yard_params)

      expect(response).to_not be_successful
      expect(response.code).to eq("404")
    end

    it "can update the purposes on an existing yard" do
      YardPurpose.destroy_all
      purposes = create_list(:purpose, 3)
      yard_params = ({
                      id: 1,
                      host_id: 1,
                      email: "host_email@domain.com",
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
      patch "/api/v1/yards/#{yard.id}", headers: headers, params: JSON.generate(new_yard_params)
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
                      email: "host_email@domain.com",
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
      patch "/api/v1/yards/#{yard.id}", headers: headers, params: JSON.generate(new_yard_params)
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

    it "can't destroy an yard that has active bookings" do
      yard = create(:yard)
      booking1 = create(:booking, status: :approved, yard_id: yard.id, date: (Date.today + 20))
      booking2 = create(:booking, status: :approved, yard_id: yard.id, date: (Date.today + 10))

      expect(Yard.count).to eq(1)

      delete "/api/v1/yards/#{yard.id}"
      returned_json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(response).to have_http_status(:not_acceptable)
      expect(returned_json[:error]).to be_a(String)
      expect(returned_json[:error]).to eq("Can't delete a yard with active bookings")
    end
  end
end
