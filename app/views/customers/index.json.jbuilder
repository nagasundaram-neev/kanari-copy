json.array!(@customers) do |customer|
  json.extract! customer, :name, :phone_number, :registered_address, :mailing_address
  json.url customer_url(customer, format: :json)
end