require "spec_helper"

describe PaymentInvoicesController do
  describe "routing" do

    it "routes to #index" do
      get("/payment_invoices").should route_to("payment_invoices#index")
    end

    it "routes to #new" do
      get("/payment_invoices/new").should route_to("payment_invoices#new")
    end

    it "routes to #show" do
      get("/payment_invoices/1").should route_to("payment_invoices#show", :id => "1")
    end

    it "routes to #edit" do
      get("/payment_invoices/1/edit").should route_to("payment_invoices#edit", :id => "1")
    end

    it "routes to #create" do
      post("/payment_invoices").should route_to("payment_invoices#create")
    end

    it "routes to #update" do
      put("/payment_invoices/1").should route_to("payment_invoices#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/payment_invoices/1").should route_to("payment_invoices#destroy", :id => "1")
    end

  end
end
