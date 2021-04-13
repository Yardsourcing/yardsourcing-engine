class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.references :yard, foreign_key: true
      t.integer :renter_id
      t.integer :status, default: 0
      t.string :booking_name
      t.date :date
      t.time :time
      t.integer :duration
      t.string :description

      t.timestamps
    end
  end
end
