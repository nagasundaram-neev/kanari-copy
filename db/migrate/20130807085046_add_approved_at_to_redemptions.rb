class AddApprovedAtToRedemptions < ActiveRecord::Migration
  def change
    add_column :redemptions, :approved_at, :datetime
  end
end
