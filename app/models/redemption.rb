class Redemption < ActiveRecord::Base
  belongs_to :user, inverse_of: :redemptions
  belongs_to :outlet, inverse_of: :redemptions
  belongs_to :staff, class_name: 'User', foreign_key: 'approved_by'

  scope :approved,    -> { where("approved_by is not null")}
  scope :notapproved, -> { where("approved_by is null")}
  scope :active,      -> {
    expiry_time = GlobalSetting.where(setting_name: 'redemption_expiry_time').first.setting_value.to_i rescue 30
    where("created_at > ?", Time.zone.now - expiry_time.minutes )
  }
  scope :pending,     -> { active.notapproved }
  scope :processed,   -> {
    expiry_time = GlobalSetting.where(setting_name: 'redemption_expiry_time').first.setting_value.to_i rescue 30
    where("created_at <= ? OR approved_by is not null", Time.zone.now - expiry_time.minutes )
  }

  def points_available?
    return ((user.points_available >= points) && outlet && (outlet.redeemable_points >= points))
  end
end
