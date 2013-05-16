json.array!(@social_network_accounts) do |social_network_account|
  json.extract! social_network_account, :access_token, :access_secret, :refresh_token, :provider, :user_id
  json.url social_network_account_url(social_network_account, format: :json)
end