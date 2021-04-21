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

  validates :renter_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def date_cant_be_in_the_past
    errors.add(:date, "Booking Date can't be in the past") if date && date < Date.today
  end

  def self.find_by_renter_and_status(renter_id, status)
    where(renter_id: renter_id)
    .where(status: status)
    .where('date >= ?', Date.today)
    .order('date')
  end

  def self.find_by_renter(renter_id)
    where(renter_id: renter_id)
    .where('date >= ?', Date.today)
    .order('date')
  end

  def self.find_by_host_and_status(host_id, status)
    joins(:yard)
    .where('yards.host_id = ?', host_id)
    .where(status: status)
  end

  def self.find_by_host(host_id)
    joins(:yard)
    .where('yards.host_id = ?', host_id)
  end
end
