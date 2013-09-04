class ManagerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :phone_number, :can_create_outlet

  def include_can_create_outlet?
    ( object.role == 'customer_admin' ) ? true : false
  end

  def can_create_outlet
    customer = object.customer
    customer && customer.authorized_outlets > customer.outlets.count
  end

end
