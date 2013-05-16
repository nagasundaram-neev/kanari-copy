class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :phone_number
      t.string :registered_address_line_1
      t.string :registered_address_line_2
      t.string :registered_address_city
      t.string :registered_address_country
      t.string :mailing_address_line_1
      t.string :mailing_address_line_2
      t.string :mailing_address_city
      t.string :mailing_address_country

      t.timestamps
    end
  end
end
