class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone_number, :registered_address_line_1,
    :registered_address_line_2, :registered_address_city, :registered_address_country,
    :mailing_address_line_1, :mailing_address_line_2, :mailing_address_city, :mailing_address_country,
    :email, :authorized_outlets, :created_at

    has_one :customer_admin, serializer: ManagerSerializer
end
