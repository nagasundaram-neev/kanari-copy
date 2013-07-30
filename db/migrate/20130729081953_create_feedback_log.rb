class CreateFeedbackLog < ActiveRecord::Migration
  def change
    create_table :feedback_logs do |t|
      t.integer   :user_id
      t.string    :user_first_name
      t.string    :user_last_name
      t.string    :user_email
      t.integer   :outlet_id
      t.string    :outlet_name
      t.integer   :customer_id
      t.integer   :feedback_id
      t.string    :code
      t.integer   :points
      t.integer   :outlet_points_before
      t.integer   :outlet_points_after
      t.integer   :user_points_before
      t.integer   :user_points_after
      t.timestamps
    end
  end
end
