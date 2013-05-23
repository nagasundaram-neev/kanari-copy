class AddPointsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :points_available, :integer
    add_column :users, :points_redeemed, :integer
  end
end
