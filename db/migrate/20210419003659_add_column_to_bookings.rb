class AddColumnToBookings < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :renter_email, :string
  end
end
