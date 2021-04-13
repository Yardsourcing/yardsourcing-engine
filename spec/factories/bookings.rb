FactoryBot.define do
  factory :booking do
    renter_id { 1 }
    status { :pending }
    booking_name { "My Event" }
    date { "2021-04-13" }
    time { "2021-04-13 16:19:51" }
    duration { 1 }
    description { "MyString" }

    yard
  end
end
