class YardSerializer
  include FastJsonapi::ObjectSerializer
  attributes  :host_id,
              :name,
              :street_address,
              :city,
              :state, 
              :zipcode, 
              :price, 
              :description, 
              :availability, 
              :payment, 
              :photo_url_1, 
              :photo_url_2, 
              :photo_url_3
end
