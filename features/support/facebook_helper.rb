require 'net/http'

def get_facebook_app_token
  uri = URI('https://graph.facebook.com/oauth/access_token')
  params = { grant_type: 'client_credentials', client_id: AppConfig[:facebook_app_id], client_secret: AppConfig[:facebook_app_secret] }
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri)
  if res.code == '200'
    response_hash = Rack::Utils.parse_query(res.body)
    return (response_hash["access_token"])
  else
    return nil
  end
end

def create_facebook_app_user
  @facebook_app_token ||= get_facebook_app_token
  uri = URI("https://graph.facebook.com/#{AppConfig[:facebook_app_id]}/accounts/test-users")
  params = {installed: true, name: 'TestUser', locale: 'en_US', permissions: 'read_stream', method: 'post', access_token: @facebook_app_token}
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri)
  if res.code == '200'
    response_hash = JSON.parse(res.body)
    return (response_hash["access_token"])
  else
    return nil
  end
end

def create_facebook_non_app_user
  @facebook_app_token ||= get_facebook_app_token
  uri = URI("https://graph.facebook.com/#{AppConfig[:facebook_app_id]}/accounts/test-users")
  params = {installed: false, name: 'TestUser', locale: 'en_US', permissions: 'read_stream', method: 'post', access_token: @facebook_app_token}
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri)
  if res.code == '200'
    response_hash = JSON.parse(res.body)
    return (response_hash["access_token"])
  else
    return nil
  end
end
