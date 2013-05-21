require 'spec_helper'

describe Api::V1::PaymentInvoicesController, pending: true do

  # This should return the minimal set of attributes required to create a valid
  # PaymentInvoice. As you add validations to PaymentInvoice, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "kanari_invoice_id" => "1" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PaymentInvoicesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all payment_invoices as @payment_invoices" do
      payment_invoice = PaymentInvoice.create! valid_attributes
      get :index, {}, valid_session
      assigns(:payment_invoices).should eq([payment_invoice])
    end
  end

  describe "GET show" do
    it "assigns the requested payment_invoice as @payment_invoice" do
      payment_invoice = PaymentInvoice.create! valid_attributes
      get :show, {:id => payment_invoice.to_param}, valid_session
      assigns(:payment_invoice).should eq(payment_invoice)
    end
  end

  describe "GET new" do
    it "assigns a new payment_invoice as @payment_invoice" do
      get :new, {}, valid_session
      assigns(:payment_invoice).should be_a_new(PaymentInvoice)
    end
  end

  describe "GET edit" do
    it "assigns the requested payment_invoice as @payment_invoice" do
      payment_invoice = PaymentInvoice.create! valid_attributes
      get :edit, {:id => payment_invoice.to_param}, valid_session
      assigns(:payment_invoice).should eq(payment_invoice)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new PaymentInvoice" do
        expect {
          post :create, {:payment_invoice => valid_attributes}, valid_session
        }.to change(PaymentInvoice, :count).by(1)
      end

      it "assigns a newly created payment_invoice as @payment_invoice" do
        post :create, {:payment_invoice => valid_attributes}, valid_session
        assigns(:payment_invoice).should be_a(PaymentInvoice)
        assigns(:payment_invoice).should be_persisted
      end

      it "redirects to the created payment_invoice" do
        post :create, {:payment_invoice => valid_attributes}, valid_session
        response.should redirect_to(PaymentInvoice.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved payment_invoice as @payment_invoice" do
        # Trigger the behavior that occurs when invalid params are submitted
        PaymentInvoice.any_instance.stub(:save).and_return(false)
        post :create, {:payment_invoice => { "kanari_invoice_id" => "invalid value" }}, valid_session
        assigns(:payment_invoice).should be_a_new(PaymentInvoice)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        PaymentInvoice.any_instance.stub(:save).and_return(false)
        post :create, {:payment_invoice => { "kanari_invoice_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested payment_invoice" do
        payment_invoice = PaymentInvoice.create! valid_attributes
        # Assuming there are no other payment_invoices in the database, this
        # specifies that the PaymentInvoice created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        PaymentInvoice.any_instance.should_receive(:update).with({ "kanari_invoice_id" => "1" })
        put :update, {:id => payment_invoice.to_param, :payment_invoice => { "kanari_invoice_id" => "1" }}, valid_session
      end

      it "assigns the requested payment_invoice as @payment_invoice" do
        payment_invoice = PaymentInvoice.create! valid_attributes
        put :update, {:id => payment_invoice.to_param, :payment_invoice => valid_attributes}, valid_session
        assigns(:payment_invoice).should eq(payment_invoice)
      end

      it "redirects to the payment_invoice" do
        payment_invoice = PaymentInvoice.create! valid_attributes
        put :update, {:id => payment_invoice.to_param, :payment_invoice => valid_attributes}, valid_session
        response.should redirect_to(payment_invoice)
      end
    end

    describe "with invalid params" do
      it "assigns the payment_invoice as @payment_invoice" do
        payment_invoice = PaymentInvoice.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        PaymentInvoice.any_instance.stub(:save).and_return(false)
        put :update, {:id => payment_invoice.to_param, :payment_invoice => { "kanari_invoice_id" => "invalid value" }}, valid_session
        assigns(:payment_invoice).should eq(payment_invoice)
      end

      it "re-renders the 'edit' template" do
        payment_invoice = PaymentInvoice.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        PaymentInvoice.any_instance.stub(:save).and_return(false)
        put :update, {:id => payment_invoice.to_param, :payment_invoice => { "kanari_invoice_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested payment_invoice" do
      payment_invoice = PaymentInvoice.create! valid_attributes
      expect {
        delete :destroy, {:id => payment_invoice.to_param}, valid_session
      }.to change(PaymentInvoice, :count).by(-1)
    end

    it "redirects to the payment_invoices list" do
      payment_invoice = PaymentInvoice.create! valid_attributes
      delete :destroy, {:id => payment_invoice.to_param}, valid_session
      response.should redirect_to(payment_invoices_url)
    end
  end

end
