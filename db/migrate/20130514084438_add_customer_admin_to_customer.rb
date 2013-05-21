class AddCustomerAdminToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :customer_admin_id, :integer
  end
end
