class Booking < ApplicationRecord
  belongs_to :yard
  validates_presence_of :booking_name,
                        :date,
                        :time,
                        :duration,
                        :description

  validates :renter_id, presence: true, numericality: {
            greater_than_or_equal_to: 0
          }

  enum status: [:pending, :approved, :rejected]

  validate :date_cant_be_in_the_past

  def date_cant_be_in_the_past
    errors.add(:date, "Booking Date can't be in the past") if date && date < Date.today
  end
end
