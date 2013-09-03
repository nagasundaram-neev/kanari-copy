class FeedbackLogSerializer < ActiveModel::Serializer
  attributes :id, :outlet_id, :outlet_name, :customer_id, :feedback_id, :code, :points, :outlet_points_before, :outlet_points_after, :user_points_before, :user_points_after, :user_first_name, :user_last_name, :user_email,  :created_at

end
