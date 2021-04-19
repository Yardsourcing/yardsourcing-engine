require 'rails_helper'

RSpec.describe EmailService do
  describe "Class Methods" do
    describe ".send_email" do
      it "make an api call to YS Microservice when called" do
        VCR.use_cassette('send_email') do
          to = "doug.welchons@gmail.com"
          from = "someone@domain.com"
          subject = "new booking created!"
          content = "a new booking has been created, click here to approve, or click here to reject"
          response = EmailService.send_email(to, from, subject, content)
          body = JSON.parse(response.body, symbolize_names: true)
          expect(response.status).to eq(202)
          expect(body[:message]).to eq("Message sent successfully")
        end
      end
    end

    describe ".new_booking" do
      it "make an api call to YS Microservice when called" do
        VCR.use_cassette('new_booking_email') do
          yard = create(:yard, id: 1)
          booking = create(:booking, id: 1, yard_id: yard.id)
          response = EmailService.new_booking(booking.id)
          body = JSON.parse(response.body, symbolize_names: true)
          expect(response.status).to eq(202)
          expect(body[:message]).to eq("Message sent successfully")
        end
      end
    end
  end
end
