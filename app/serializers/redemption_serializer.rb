class RedemptionSerializer < ActiveModel::Serializer
  attributes :id, :outlet_id, :points, :created_at, :updated_at, :approved_by

  has_one :user, serializer: UserSerializer
end
