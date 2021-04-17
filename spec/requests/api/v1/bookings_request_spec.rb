require 'rails_helper'

RSpec.describe 'Bookings API SPEC'do
  describe 'Booking Details' do
    describe 'happy path' do
      it 'can return a specific booking by id' do
        create_list(:booking, 10)
        booking_id = Booking.all.first
        get "/api/v1/bookings/#{booking_id.id}"
        expect(response).to be_successful
        booking = JSON.parse(response.body, symbolize_names:true)
        expect(booking).to be_a(Hash)
        expect(booking[:data]).to be_a(Hash)
        expect(booking[:data].count).to eq(3)
        expect(booking[:data][:attributes].count).to eq(8)
        expect(booking[:data][:attributes]).to have_key(:status)
        expect(booking[:data][:attributes]).to have_key(:booking_name)
        expect(booking[:data][:attributes]).to have_key(:date)
        expect(booking[:data][:attributes]).to have_key(:description)
        expect(booking[:data][:attributes]).to have_key(:duration)
        expect(booking[:data][:attributes]).to have_key(:time)
        expect(booking[:data][:attributes]).to have_key(:renter_id)
        expect(booking[:data][:attributes]).to have_key(:booking_id)
        expect(booking[:data][:attributes][:renter_id]).to be_a(Integer)
        expect(booking[:data][:attributes][:booking_id]).to be_a(Integer)
        expect(booking[:data][:attributes][:duration]).to be_a(Integer)
        expect(booking[:data][:attributes][:description]).to be_a(String)
        expect(booking[:data][:attributes][:status]).to be_a(String)
        expect(booking[:data][:attributes][:booking_name]).to be_a(String)
        expect(booking[:data][:attributes][:time]).to be_a(String)
      end

      it 'returns the correct booking' do
        create_list(:booking, 10)
        booking = create(:booking, status: :approved, booking_name: "fun", duration:100)
        special_booking = Booking.all.last
        get "/api/v1/bookings/#{special_booking.id}"
        expect(response).to be_successful
        booking = JSON.parse(response.body, symbolize_names:true)
        expect(booking[:data][:attributes][:renter_id]).to eq(special_booking.renter_id)
        expect(booking[:data][:attributes][:booking_id]).to eq(special_booking.booking_id)
        expect(booking[:data][:attributes][:duration]).to eq(special_booking.duration)
        expect(booking[:data][:attributes][:status]).to eq(special_booking.status)
        expect(booking[:data][:attributes][:booking_name]).to eq(special_booking.booking_name)
        expect(booking[:data][:attributes][:description]).to eq(special_booking.description)
      end
    end

    describe 'sad path' do
      it 'errors out when no bookings match id' do
        create_list(:booking, 10)
        booking = create(:booking, status: :approved, booking_name: "fun", duration:100)
        get "/api/v1/bookings/akjfkjkjkd"
        expect(response.status).to eq(400)
        error = JSON.parse(response.body, symbolize_names:true)
        expect(error).to be_a(Hash)
        expect(error[:error]).to be_a(String)
      end

      it 'should return an empty array if no ids exist' do
        create_list(:booking, 10)
        booking = create(:booking, status: :approved, booking_name: "fun", duration:100)
        get "/api/v1/bookings/100000000"
        expect(response.status).to eq(404)
        expect(response.body).to eq("Record not found")
      end
    end
  end
  describe "CRUD Functionality" do
    it "can create a new booking" do
      yard = create(:yard)
      booking_params = ({
        yard_id: yard.id,
        renter_id: 1,
        status: :pending,
        booking_name: "Super Fun Time, BBQ",
        date: Date.new(2021,04,25),
        time: Time.new(2021, 04, 25, 14).strftime("%H:%M"),
        duration: 3,
        description: "Gonna be a super great cookout! BYOB"
        })

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/bookings", headers: headers, params: JSON.generate(booking: booking_params)
      created_booking = Booking.last

      expect(response).to be_successful
      expect(created_booking.yard_id).to eq(booking_params[:yard_id])
      expect(created_booking.renter_id).to eq(booking_params[:renter_id])
      expect(created_booking.status).to eq(booking_params[:status])
      expect(created_booking.booking_name).to eq(booking_params[:booking_name])
      expect(created_booking.date).to eq(booking_params[:date])
      expect(created_booking.time).to eq(booking_params[:time])
      expect(created_booking.duration).to eq(booking_params[:duration])
      expect(created_booking.description).to eq(booking_params[:description])

      expect(response).to have_http_status(:created)
      booking = JSON.parse(response.body, symbolize_names: true)
    end
    #
    # it "Won't create a new booking with missing information" do
    #   purposes = create_list(:purpose, 3)
    #   booking_params = ({
    #                   id: 1,
    #                   street_address: "123 Fake St.",
    #                   city: "Denver",
    #                   state: "CO",
    #                   zipcode: '12345',
    #                   price: 20.00,
    #                   description: 'description',
    #                   availability: 'availability',
    #                   payment: 'venmo',
    #                   photo_url_1: 'url1',
    #                   photo_url_2: 'url2',
    #                   photo_url_3: 'url3',
    #                   purposes: [purposes.first.id, purposes.last.id]
    #                 })
    #   headers = {"CONTENT_TYPE" => "application/json"}
    #
    #   post "/api/v1/bookings", headers: headers, params: JSON.generate(booking: booking_params)
    #
    #   expect(response).to have_http_status(:not_found)
    # end
    #
    # it "Won't create a new booking when there are no purposes" do
    #   booking_params = ({
    #                   id: 1,
    #                   host_id: 1,
    #                   name: 'booking',
    #                   street_address: "123 Fake St.",
    #                   city: "Denver",
    #                   state: "CO",
    #                   zipcode: '12345',
    #                   price: 20.00,
    #                   description: 'description',
    #                   availability: 'availability',
    #                   payment: 'venmo',
    #                   photo_url_1: 'url1',
    #                   photo_url_2: 'url2',
    #                   photo_url_3: 'url3'
    #                 })
    #   headers = {"CONTENT_TYPE" => "application/json"}
    #
    #   post "/api/v1/bookings", headers: headers, params: JSON.generate(booking: booking_params)
    #   returned_json = JSON.parse(response.body, symbolize_names: true)
    #
    #   expect(response).to have_http_status(:not_acceptable)
    #   expect(returned_json[:error]).to be_a(String)
    #   expect(returned_json[:error]).to eq("You must select at least one purpose")
    # end
    #
    # it "can update an existing booking and remove a purpose when necessary" do
    #   purposes = create_list(:purpose, 3)
    #   booking = create(:booking)
    #   booking.purposes << [purposes]
    #   id = booking.id
    #   previous_name = Booking.last.name
    #   booking_params = { name: "New Name", purposes: [purposes.first.id, purposes.last.id] }
    #   headers = {"CONTENT_TYPE" => "application/json"}
    #   expect(booking.purposes.count).to eq(3)
    #
    #   patch "/api/v1/bookings/#{id}", headers: headers, params: JSON.generate({booking: booking_params})
    #
    #   booking = Booking.find_by(id: id)
    #   expect(response).to be_successful
    #   expect(booking.name).to_not eq(previous_name)
    #   expect(booking.name).to eq(booking_params[:name])
    #   expect(booking.purposes.count).to eq(2)
    # end
    #
    # it "can update an existing booking and create a purpose that doesn't exist" do
    #   purposes = create_list(:purpose, 3)
    #   booking = create(:booking)
    #   booking.purposes << [purposes.first, purposes.second]
    #   id = booking.id
    #   previous_name = Booking.last.name
    #   booking_params = { name: "New Name", purposes: purposes.map(&:id) }
    #   headers = {"CONTENT_TYPE" => "application/json"}
    #   expect(booking.purposes.count).to eq(2)
    #
    #   patch "/api/v1/bookings/#{id}", headers: headers, params: JSON.generate({booking: booking_params})
    #
    #   booking = Booking.find_by(id: id)
    #   expect(response).to be_successful
    #   expect(booking.name).to_not eq(previous_name)
    #   expect(booking.name).to eq(booking_params[:name])
    #   expect(booking.purposes.count).to eq(3)
    # end
    #
    # it "can't update an existing booking when all purposes have been removed" do
    #   purposes = create_list(:purpose, 3)
    #   booking = create(:booking)
    #   booking.purposes << [purposes]
    #   id = booking.id
    #   previous_name = Booking.last.name
    #   booking_params = { name: "New Name"}
    #   headers = {"CONTENT_TYPE" => "application/json"}
    #   expect(booking.purposes.count).to eq(3)
    #
    #   patch "/api/v1/bookings/#{id}", headers: headers, params: JSON.generate({booking: booking_params})
    #   booking = Booking.find_by(id: id)
    #   returned_json = JSON.parse(response.body, symbolize_names: true)
    #
    #   expect(response).to have_http_status(:not_acceptable)
    #   expect(returned_json[:error]).to be_a(String)
    #   expect(returned_json[:error]).to eq("You must select at least one purpose")
    #   expect(booking.name).to eq(previous_name)
    #   expect(booking.purposes.count).to eq(3)
    #
    # end
    #
    # it "can't update an booking that doesn't exist" do
    #   booking_params = { name: "New Name" }
    #   headers = {"CONTENT_TYPE" => "application/json"}
    #
    #   patch "/api/v1/bookings/#{99999999}", headers: headers, params: JSON.generate({booking: booking_params})
    #   expect(response).to_not be_successful
    #   expect(response).to have_http_status(:not_found)
    # end
    #
    # it "can't update an existing booking with a bad ID" do
    #   id = 1000000
    #   booking_params = ({
    #                   id: id,
    #                   street_address: "123 Fake St.",
    #                   city: "Denver",
    #                   state: "CO",
    #                   zipcode: '12345',
    #                   price: 20.00,
    #                   description: 'description',
    #                   availability: 'availability',
    #                   payment: 'venmo',
    #                   photo_url_1: 'url1',
    #                   photo_url_2: 'url2',
    #                   photo_url_3: 'url3'
    #                 })
    #   headers = {"CONTENT_TYPE" => "application/json"}
    #
    #   patch "/api/v1/bookings/#{id}", headers: headers, params: JSON.generate({booking: booking_params})
    #
    #   expect(response).to_not be_successful
    #   expect(response.code).to eq("404")
    # end
    #
    # it "can update the purposes on an existing booking" do
    #   BookingPurpose.destroy_all
    #   purposes = create_list(:purpose, 3)
    #   booking_params = ({
    #                   id: 1,
    #                   host_id: 1,
    #                   name: 'booking',
    #                   street_address: '123 Fake St.',
    #                   city: 'Denver',
    #                   state: 'CO',
    #                   zipcode: '12345',
    #                   price: 20.00,
    #                   description: 'description',
    #                   availability: 'availability',
    #                   payment: 'venmo',
    #                   photo_url_1: 'url1',
    #                   photo_url_2: 'url2',
    #                   photo_url_3: 'url3'
    #                 })
    #   booking = Booking.create!(booking_params)
    #   create(:booking_purpose, booking: booking, purpose: purposes.first)
    #
    #   headers = {"CONTENT_TYPE" => "application/json"}
    #   new_booking_params = ({
    #                   purposes: [purposes.first.id,purposes.second.id, purposes.last.id]
    #                 })
    #   patch "/api/v1/bookings/#{booking.id}", headers: headers, params: JSON.generate({booking: new_booking_params})
    #   booking = Booking.find_by(id: booking.id)
    #   expect(response).to be_successful
    #
    #   expect(booking.purposes.find(purposes.first.id)).to eq(purposes.first)
    #   expect(booking.purposes.find(purposes.second.id)).to eq(purposes.second)
    #   expect(booking.purposes.find(purposes.last.id)).to eq(purposes.last)
    # end
    #
    # it "can delete the purposes on an existing booking that are no longer checked" do
    #   BookingPurpose.destroy_all
    #   purposes = create_list(:purpose, 3)
    #   booking_params = ({
    #                   id: 1,
    #                   host_id: 1,
    #                   name: 'booking',
    #                   street_address: '123 Fake St.',
    #                   city: 'Denver',
    #                   state: 'CO',
    #                   zipcode: '12345',
    #                   price: 20.00,
    #                   description: 'description',
    #                   availability: 'availability',
    #                   payment: 'venmo',
    #                   photo_url_1: 'url1',
    #                   photo_url_2: 'url2',
    #                   photo_url_3: 'url3'
    #                 })
    #   booking = Booking.create!(booking_params)
    #   create(:booking_purpose, booking: booking, purpose: purposes.first)
    #
    #   headers = {"CONTENT_TYPE" => "application/json"}
    #   new_booking_params = ({
    #                   purposes: [purposes.second.id, purposes.last.id]
    #                 })
    #   patch "/api/v1/bookings/#{booking.id}", headers: headers, params: JSON.generate({booking: new_booking_params})
    #   booking = Booking.find_by(id: booking.id)
    #   expect(response).to be_successful
    #
    #   expect(booking.purposes.where(id: purposes.first.id)).to eq([])
    #   expect(booking.purposes.find(purposes.second.id)).to eq(purposes.second)
    #   expect(booking.purposes.find(purposes.last.id)).to eq(purposes.last)
    # end
    #
    # it "can destroy an booking" do
    #   booking = create(:booking)
    #
    #   expect(Booking.count).to eq(1)
    #
    #   delete "/api/v1/bookings/#{booking.id}"
    #
    #   expect(response).to be_successful
    #   expect(Booking.count).to eq(0)
    #   expect{Booking.find(booking.id)}.to raise_error(ActiveRecord::RecordNotFound)
    # end
  end
end
