require "spec_helper"

describe SocialNetworkAccountsController do
  describe "routing" do

    it "routes to #index" do
      get("/social_network_accounts").should route_to("social_network_accounts#index")
    end

    it "routes to #new" do
      get("/social_network_accounts/new").should route_to("social_network_accounts#new")
    end

    it "routes to #show" do
      get("/social_network_accounts/1").should route_to("social_network_accounts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/social_network_accounts/1/edit").should route_to("social_network_accounts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/social_network_accounts").should route_to("social_network_accounts#create")
    end

    it "routes to #update" do
      put("/social_network_accounts/1").should route_to("social_network_accounts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/social_network_accounts/1").should route_to("social_network_accounts#destroy", :id => "1")
    end

  end
end
