class AddRedeemsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :redeems_count, :integer
  end
end
