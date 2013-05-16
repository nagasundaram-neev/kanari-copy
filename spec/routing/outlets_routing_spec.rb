require "spec_helper"

describe OutletsController do
  describe "routing" do

    it "routes to #index" do
      get("/outlets").should route_to("outlets#index")
    end

    it "routes to #new" do
      get("/outlets/new").should route_to("outlets#new")
    end

    it "routes to #show" do
      get("/outlets/1").should route_to("outlets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/outlets/1/edit").should route_to("outlets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/outlets").should route_to("outlets#create")
    end

    it "routes to #update" do
      put("/outlets/1").should route_to("outlets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/outlets/1").should route_to("outlets#destroy", :id => "1")
    end

  end
end
