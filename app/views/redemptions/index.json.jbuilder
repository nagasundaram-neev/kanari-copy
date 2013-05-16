json.array!(@redemptions) do |redemption|
  json.extract! redemption, :user_id, :outlet_id, :points
  json.url redemption_url(redemption, format: :json)
end