class AddColumnToYards < ActiveRecord::Migration[5.2]
  def change
    add_column :yards, :email, :string
  end
end
