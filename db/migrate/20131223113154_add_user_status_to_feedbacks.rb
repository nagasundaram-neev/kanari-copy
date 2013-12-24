class AddUserStatusToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :user_status, :string, default: "reach_out"
  end
end
