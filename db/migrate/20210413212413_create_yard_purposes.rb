class CreateYardPurposes < ActiveRecord::Migration[5.2]
  def change
    create_table :yard_purposes do |t|
      t.references :yard, foreign_key: true
      t.references :purpose, foreign_key: true

      t.timestamps
    end
  end
end
