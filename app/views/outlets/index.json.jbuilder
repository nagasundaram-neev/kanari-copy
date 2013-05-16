json.array!(@outlets) do |outlet|
  json.extract! outlet, :name, :address, :geolocation, :website_url, :email, :points, :phone_number, :open_hours, :has_delivery, :serves_alcohol, :has_outdoor_seating, :customer_id
  json.url outlet_url(outlet, format: :json)
end