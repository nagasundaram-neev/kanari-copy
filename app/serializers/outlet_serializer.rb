class OutletSerializer < ActiveModel::Serializer
  attributes :id, :name, :disabled, :address, :latitude, :longitude, :website_url, :email, :phone_number, :open_hours, :has_delivery, :serves_alcohol,
  :has_outdoor_seating

  has_one :manager, serializer: ManagerSerializer
  has_many :cuisine_types
  has_many :outlet_types
end
