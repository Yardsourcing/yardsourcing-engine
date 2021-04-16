class AddUniqueIndexToYardPurposes < ActiveRecord::Migration[5.2]
  def change
    add_index :yard_purposes, [:yard_id, :purpose_id], unique: true
  end
end
