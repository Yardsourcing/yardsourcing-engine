class BookingSerializer
  include FastJsonapi::ObjectSerializer
  attributes :status, :yard_id, :booking_name, :renter_id, :date, :time,
    :duration, :description
end
