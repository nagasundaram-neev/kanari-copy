class AddAuthorizedOutletsToCustomer < ActiveRecord::Migration
  def up
    add_column :customers, :authorized_outlets, :integer, :default => 1
  end
  def down
    remove_column :customers, :authorized_outlets
  end
end
