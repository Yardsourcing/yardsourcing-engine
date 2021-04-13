class Yard < ApplicationRecord
  has_many :yard_purposes, dependent: :destroy
  has_many :purposes, through: :yard_purposes
  has_many :bookings

  validates :host_id, presence: true, numericality: {
            greater_than_or_equal_to: 0
          }
  validates_presence_of :name
  validates :zipcode, numericality: {
            greater_than_or_equal_to: 0
          }
end
