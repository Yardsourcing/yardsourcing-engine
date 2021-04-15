class UpdateZipcodeOnYardTable < ActiveRecord::Migration[5.2]
  def change
    change_column :yards, :zipcode, :string
  end
end
