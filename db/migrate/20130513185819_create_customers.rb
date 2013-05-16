class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :phone_number
      t.text :registered_address
      t.text :mailing_address

      t.timestamps
    end
  end
end
