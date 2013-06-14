class SetDefaultPoints < ActiveRecord::Migration
  def up
    change_column :users, :points_available, :integer, :default => 0
    change_column :outlets, :rewards_pool, :integer, :default => 0
    change_column :feedbacks, :user_points_after_feedback, :integer, :default => 0
    change_column :feedbacks, :rewards_pool_after_feedback, :integer, :default => 0
  end

  def down
    change_column :users, :points_available, :integer, :default => nil
    change_column :outlets, :rewards_pool, :integer, :default => nil
    change_column :feedbacks, :user_points_after_feedback, :integer, :default => nil
    change_column :feedbacks, :rewards_pool_after_feedback, :integer, :default => nil
  end
end
