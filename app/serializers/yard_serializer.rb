class YardSerializer
  include FastJsonapi::ObjectSerializer
  attributes  :host_id,
              :name,
              :street_address,
              :city,
              :state,
              :zipcode,
              :description,
              :availability,
              :payment,
              :photo_url_1,
              :photo_url_2,
              :photo_url_3

  attribute :price do |object|
    object.price.to_f
  end

  attribute :purposes do |object|
    PurposeSerializer.new(object.purposes)
  end
end
