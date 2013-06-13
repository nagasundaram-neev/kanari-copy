class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :gender, :date_of_birth, :email, :location, :points_available, :points_redeemed
end
