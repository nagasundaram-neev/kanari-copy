class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :gender, :date_of_birth, :email, :location, :points_available, :points_redeemed, :tablet_id, :phone_number, :redeems_count

  def include_redeems_count?
    object.role == 'user'
  end

  def include_tablet_id?
    object.role == 'staff'
  end

  def include_phone_number?
    object.role != 'staff'
  end

  def tablet_id
    object.email.split('@')[0]
  end
end
