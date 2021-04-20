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
        expect(booking[:data][:attributes]).to have_key(:yard_id)
        expect(booking[:data][:attributes][:renter_id]).to be_a(Integer)
        expect(booking[:data][:attributes][:yard_id]).to be_a(Integer)
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
        expect(booking[:data][:attributes][:yard_id]).to eq(special_booking.yard_id)
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
        bad_id = 100000000
        get "/api/v1/bookings/#{bad_id}"
        error = JSON.parse(response.body, symbolize_names:true)

        expect(response.status).to eq(404)
        expect(error).to have_key(:error)
        expect(error[:error]).to eq("Couldn't find Booking with 'id'=#{bad_id}")
      end
    end
  end
  describe "CRUD Functionality" do
    it "can create a new booking" do
      VCR.use_cassette("new_booking") do
        yard = create(:yard)
        booking_params = ({
          yard_id: yard.id,
          renter_id: 1,
          renter_email: 'email@domain.com',
          status: :pending,
          booking_name: "Super Fun Time, BBQ",
          date: Date.new(2021,04,25),
          time: Time.new(2021, 04, 25, 14).strftime("%H:%M"),
          duration: 3,
          description: "Gonna be a super great cookout! BYOB"
          })

        headers = {"CONTENT_TYPE" => "application/json"}

        post "/api/v1/bookings", headers: headers, params: JSON.generate(booking_params)
        created_booking = Booking.last

        expect(response).to be_successful
        expect(created_booking.yard_id).to eq(booking_params[:yard_id])
        expect(created_booking.renter_id).to eq(booking_params[:renter_id])
        expect(created_booking.status).to eq(booking_params[:status].to_s)
        expect(created_booking.booking_name).to eq(booking_params[:booking_name])
        expect(created_booking.date).to eq(booking_params[:date])
        expect(created_booking.time.strftime("%H:%M")).to eq(booking_params[:time])
        expect(created_booking.duration).to eq(booking_params[:duration])
        expect(created_booking.description).to eq(booking_params[:description])

        expect(response).to have_http_status(:created)
        booking = JSON.parse(response.body, symbolize_names: true)
      end
    end

    it "Won't create a new booking with missing information" do
      booking_params = ({
        renter_id: 1,
        status: :pending,
        booking_name: "Super Fun Time, BBQ",
        date: Date.new(2021,04,25),
        time: Time.new(2021, 04, 25, 14).strftime("%H:%M"),
        duration: 3,
        description: "Gonna be a super great cookout! BYOB"
        })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/bookings", headers: headers, params: JSON.generate(booking_params)

      error = JSON.parse(response.body, symbolize_names:true)
      error_message = "Validation failed: Yard must exist, Renter email can't be blank, Renter email is invalid"

      expect(response).to have_http_status(:not_found)
      expect(error).to have_key(:error)
      expect(error[:error]).to eq("#{error_message}")
    end

    it "can update an existing booking to approved" do
      VCR.use_cassette('approved_booking') do
        booking = create(:booking)
        id = booking.id
        booking_params = { status: :approved }
        headers = {"CONTENT_TYPE" => "application/json"}

       put "/api/v1/bookings/#{id}", headers: headers, params: JSON.generate(booking_params)

        booking = Booking.find_by(id: id)
        expect(response).to be_successful
        expect(booking.pending?).to_not eq(true)
        expect(booking.approved?).to eq(true)
      end
    end

    it "can update an existing booking to rejected" do
      VCR.use_cassette('rejected_booking') do
        booking = create(:booking)
        id = booking.id
        booking_params = { status: :rejected }
        headers = {"CONTENT_TYPE" => "application/json"}

        put "/api/v1/bookings/#{id}", headers: headers, params: JSON.generate(booking_params)

        booking = Booking.find_by(id: id)
        expect(response).to be_successful
        expect(booking.pending?).to_not eq(true)
        expect(booking.rejected?).to eq(true)
      end
    end

    it "can't update an booking that doesn't exist" do
      booking_params = { name: "New Name" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/bookings/#{99999999}", headers: headers, params: JSON.generate(booking_params)
      expect(response).to_not be_successful
      expect(response).to have_http_status(:not_found)
    end

    it "can't update an existing booking with a bad ID" do
      id = 1000000
      yard = create(:yard)
      booking_params = ({
        yard_id: yard.id,
        renter_id: 1,
        status: :pending,
        booking_name: "Super Fun Time, BBQ",
        date: Date.new(2021,04,25),
        time: Time.new(2021, 04, 25, 14).strftime("%H:%M"),
        duration: 3,
        description: "Gonna be a super great cookout! BYOB",
        id: id
        })
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/bookings/#{id}", headers: headers, params: JSON.generate(booking_params)

      expect(response).to_not be_successful
      expect(response.code).to eq("404")
    end

    it "can destroy an booking" do
      booking = create(:booking)

      expect(Booking.count).to eq(1)

      delete "/api/v1/bookings/#{booking.id}"

      expect(response).to be_successful
      expect(Booking.count).to eq(0)
      expect{Booking.find(booking.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
