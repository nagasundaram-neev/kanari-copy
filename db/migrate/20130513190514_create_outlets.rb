class CreateOutlets < ActiveRecord::Migration
  def change
    create_table :outlets do |t|
      t.string :name
      t.text :address
      t.float :latitude
      t.float :longitude
      t.string :website_url
      t.string :email
      t.integer :rewards_pool
      t.integer :points_redeemed
      t.string :phone_number
      t.string :open_hours
      t.boolean :has_delivery
      t.boolean :serves_alcohol
      t.boolean :has_outdoor_seating
      t.references :customer, index: true

      t.timestamps
    end
  end
end
