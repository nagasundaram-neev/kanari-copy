require "spec_helper"

describe Api::V1::RedemptionsController, pending: true do
  describe "routing" do

    it "routes to #index" do
      get("/redemptions").should route_to("redemptions#index")
    end

    it "routes to #new" do
      get("/redemptions/new").should route_to("redemptions#new")
    end

    it "routes to #show" do
      get("/redemptions/1").should route_to("redemptions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/redemptions/1/edit").should route_to("redemptions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/redemptions").should route_to("redemptions#create")
    end

    it "routes to #update" do
      put("/redemptions/1").should route_to("redemptions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/redemptions/1").should route_to("redemptions#destroy", :id => "1")
    end

  end
end
