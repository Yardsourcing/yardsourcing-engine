FactoryBot.define do
  factory :yard do
    host_id { 1 }
    name { "My Yard" }
    street_address { "123 Fake St" }
    city { "Denver" }
    state { "CO" }
    zipcode { '12345' }
    price { "9.99" }
    description { "MyString" }
    availability { "MyString" }
    payment { "MyString" }
    photo_url_1 { "MyString" }
    photo_url_2 { "MyString" }
    photo_url_3 { "MyString" }
  end
end
