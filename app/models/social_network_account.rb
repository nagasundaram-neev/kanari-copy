class SocialNetworkAccount < ActiveRecord::Base
  belongs_to :user, inverse_of: :social_network_accounts
end
