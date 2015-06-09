class AddLatitudeAndLongitudeToSale < ActiveRecord::Migration
  def change
    add_column :sales, :latitude,  :float, default: 0, null: false
    add_column :sales, :longitude, :float, default: 0, null: false
  end
end
