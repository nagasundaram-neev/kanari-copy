class RedemptionLogSerializer < ActiveModel::Serializer
  attributes :id, :outlet_id, :outlet_name, :customer_id, :redemption_id, :points, :outlet_points_before, :outlet_points_after, :user_points_before, :user_points_after, :user_first_name, :user_last_name, :user_email,  :created_at, :tablet_id

  def tablet_id
    object.generated_by && object.generated_by.split('@').first.to_s
  end
end
