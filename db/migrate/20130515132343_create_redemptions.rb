class CreateRedemptions < ActiveRecord::Migration
  def change
    create_table :redemptions do |t|
      t.references :user, index: true
      t.references :outlet, index: true
      t.integer :points
      t.integer :rewards_pool_after_redemption
      t.integer :user_points_after_redemption
      t.integer :approved_by, index: true

      t.timestamps
    end
  end
end
