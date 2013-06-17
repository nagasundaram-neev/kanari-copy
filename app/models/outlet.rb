class Outlet < ActiveRecord::Base
  belongs_to :customer, inverse_of: :outlets
  has_many :feedbacks, inverse_of: :outlet
  has_many :redemptions, inverse_of: :outlet
  belongs_to :manager, -> { where role: 'manager'}, class_name: 'User'
  has_many :outlets_cuisine_types
  has_many :cuisine_types, through: :outlets_cuisine_types
  has_many :outlets_outlet_types
  has_many :outlet_types, through: :outlets_outlet_types
  has_many :outlets_staffs
  has_many :staffs, through: :outlets_staffs

  def redeemable_points
    rewards_pool - points_pending_redemption
  end

  def points_pending_redemption
    redemptions.where(approved_by: nil).sum(:points)
  end
end
