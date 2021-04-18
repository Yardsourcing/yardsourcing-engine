require 'rails_helper'

RSpec.describe EmailService do
  describe "Class Methods" do
    describe ".send_email" do
      it "make an api call to YS Microservice when called" do
        to = "doug.welchons@gmail.com"
        from = "someone@domain.com"
        subject = "new booking created!"
        content = "a new booking has been created, click here to approve, or click here to reject"
        method_call = EmailService.send_email(to, from, subject, content)
        expect(method_call.status).to eq(202)
      end
    end
  end
end
