class CreateCustomersUsers < ActiveRecord::Migration
  def change
    create_table :customers_users do |t|
      t.references :customer, index: true
      t.references :user, index: true
    end
  end
end
