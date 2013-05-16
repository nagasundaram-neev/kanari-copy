class CreateSocialNetworkAccounts < ActiveRecord::Migration
  def change
    create_table :social_network_accounts do |t|
      t.string :access_token
      t.string :access_secret
      t.string :refresh_token
      t.string :provider
      t.references :user, index: true

      t.timestamps
    end
  end
end
