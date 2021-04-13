class Booking < ApplicationRecord
  belongs_to :yard
  validates_presence_of :booking_name

  validates :renter_id, presence: true, numericality: {
            greater_than_or_equal_to: 0
          }

  enum status: [:pending, :approved, :rejected]
end
