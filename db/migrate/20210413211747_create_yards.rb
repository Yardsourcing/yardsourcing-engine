class CreateYards < ActiveRecord::Migration[5.2]
  def change
    create_table :yards do |t|
      t.integer :host_id
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zipcode
      t.decimal :price
      t.string :description
      t.string :availability
      t.string :payment
      t.string :photo_url_1
      t.string :photo_url_2
      t.string :photo_url_3

      t.timestamps
    end
  end
end
