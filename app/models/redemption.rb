class Redemption < ActiveRecord::Base
  belongs_to :user, inverse_of: :redemptions
  belongs_to :outlet, inverse_of: :redemptions
  belongs_to :staff, class_name: 'User', foreign_key: 'approved_by'

  scope :approved,   -> { where("approved_by is not null")}
  
  def points_available?
    return ((user.points_available >= points) && outlet && (outlet.redeemable_points >= points))
  end
end
