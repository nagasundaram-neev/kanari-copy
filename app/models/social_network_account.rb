class SocialNetworkAccount < ActiveRecord::Base
  belongs_to :user, inverse_of: :social_network_accounts

  def self.valid_access_token?(provider, access_token)
    case provider
    when 'facebook'
      #uri = URI('https://graph.facebook.com/me')
      #params = { :fields => 'email', :access_token => access_token }

      uri = URI('https://graph.facebook.com/oauth/access_token')
      params = { grant_type: 'fb_exchange_token', client_id: AppConfig[:facebook_app_id], client_secret: AppConfig[:facebook_app_secret], fb_exchange_token: access_token}
      uri.query = URI.encode_www_form(params)

      res = Net::HTTP.get_response(uri)
      if res.code == '200'
        response_hash = Rack::Utils.parse_query(res.body)
        if response_hash["access_token"]
          access_token.replace(response_hash["access_token"])
          return true
        end
      end
    else
      return false
    end
    return false
  end
end
