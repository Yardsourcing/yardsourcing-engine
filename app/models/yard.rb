class Yard < ApplicationRecord
  has_many :yard_purposes, dependent: :destroy
  has_many :purposes, through: :yard_purposes
  has_many :bookings

  validates :host_id, presence: true, numericality: {
            greater_than_or_equal_to: 0
          }
  validates :price, presence: true, numericality: {
            greater_than_or_equal_to: 0
          }
  validates_presence_of :name,
                        :street_address,
                        :city,
                        :state,
                        :zipcode,
                        :availability,
                        :payment

  def self.yards_by_zipcode(zipcode)
    where(zipcode: zipcode)
  end

  def self.yards_by_zipcode_and_purposes(zipcode, purposes)
    joins(:purposes)
    .where(zipcode: zipcode)
    .where('purposes.name in (?)', purposes)
    .distinct
  end
end
