class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :units,              null: false
      t.string :first_name,          null: false
      t.string :last_name,           null: false
      t.string :address,             null: false
      t.string :address2
      t.string  :city,               null: false
      t.integer :zip,                null: false
      t.string  :country,            null: false
      t.integer :credit_card_number, null: false, limit: 8
      t.string    :credit_card_date, null: false
      t.integer :credit_card_ccv,    null: false
      t.boolean :shipped,            default: false, null: false

      t.timestamps                   null: false
    end
  end
end
