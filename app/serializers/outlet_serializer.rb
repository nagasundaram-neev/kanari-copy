class OutletSerializer < ActiveModel::Serializer
  attributes :id, :name, :disabled, :address, :latitude, :longitude, :website_url, :email, :phone_number, :open_hours, :has_delivery, :serves_alcohol,
  :has_outdoor_seating, :redeemable_points, :points_pending_redemption

  has_one :manager, serializer: ManagerSerializer
  has_many :cuisine_types
  has_many :outlet_types

  def redeemable_points
    if current_user.role == 'user'
      [current_user.points_available, object.redeemable_points].min
    else
      object.redeemable_points
    end
  end

  def include_points_pending_redemption?
    ability = Ability.new(current_user)
    ability.can? :read_all_redemptions, Outlet
  end

end
