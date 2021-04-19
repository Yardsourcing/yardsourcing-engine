FactoryBot.define do
  factory :booking do
    renter_id { 1 }
    renter_email { "email@domain.com" }
    status { :pending }
    booking_name { "My Event" }
    date { DateTime.now }
    time { DateTime.now }
    duration { 1 }
    description { "MyString" }

    yard
  end
end
