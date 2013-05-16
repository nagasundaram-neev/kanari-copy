require 'spec_helper'

describe CustomersController, pending: true do

  # This should return the minimal set of attributes required to create a valid
  # Customer. As you add validations to Customer, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "name" => "MyString" } }


  describe "GET index" do
    it "assigns all customers as @customers" do
      customer = Customer.create! valid_attributes
      get :index, {}, valid_session
      assigns(:customers).should eq([customer])
    end
  end

  describe "GET show" do
    it "assigns the requested customer as @customer" do
      customer = Customer.create! valid_attributes
      get :show, {:id => customer.to_param}, valid_session
      assigns(:customer).should eq(customer)
    end
  end

  describe "GET new" do
    it "assigns a new customer as @customer" do
      get :new, {}, valid_session
      assigns(:customer).should be_a_new(Customer)
    end
  end

  describe "GET edit" do
    it "assigns the requested customer as @customer" do
      customer = Customer.create! valid_attributes
      get :edit, {:id => customer.to_param}, valid_session
      assigns(:customer).should eq(customer)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Customer" do
        expect {
          post :create, {:customer => valid_attributes}, valid_session
        }.to change(Customer, :count).by(1)
      end

      it "assigns a newly created customer as @customer" do
        post :create, {:customer => valid_attributes}, valid_session
        assigns(:customer).should be_a(Customer)
        assigns(:customer).should be_persisted
      end

      it "redirects to the created customer" do
        post :create, {:customer => valid_attributes}, valid_session
        response.should redirect_to(Customer.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved customer as @customer" do
        # Trigger the behavior that occurs when invalid params are submitted
        Customer.any_instance.stub(:save).and_return(false)
        post :create, {:customer => { "name" => "invalid value" }}, valid_session
        assigns(:customer).should be_a_new(Customer)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Customer.any_instance.stub(:save).and_return(false)
        post :create, {:customer => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested customer" do
        customer = Customer.create! valid_attributes
        # Assuming there are no other customers in the database, this
        # specifies that the Customer created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Customer.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => customer.to_param, :customer => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested customer as @customer" do
        customer = Customer.create! valid_attributes
        put :update, {:id => customer.to_param, :customer => valid_attributes}, valid_session
        assigns(:customer).should eq(customer)
      end

      it "redirects to the customer" do
        customer = Customer.create! valid_attributes
        put :update, {:id => customer.to_param, :customer => valid_attributes}, valid_session
        response.should redirect_to(customer)
      end
    end

    describe "with invalid params" do
      it "assigns the customer as @customer" do
        customer = Customer.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Customer.any_instance.stub(:save).and_return(false)
        put :update, {:id => customer.to_param, :customer => { "name" => "invalid value" }}, valid_session
        assigns(:customer).should eq(customer)
      end

      it "re-renders the 'edit' template" do
        customer = Customer.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Customer.any_instance.stub(:save).and_return(false)
        put :update, {:id => customer.to_param, :customer => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested customer" do
      customer = Customer.create! valid_attributes
      expect {
        delete :destroy, {:id => customer.to_param}, valid_session
      }.to change(Customer, :count).by(-1)
    end

    it "redirects to the customers list" do
      customer = Customer.create! valid_attributes
      delete :destroy, {:id => customer.to_param}, valid_session
      response.should redirect_to(customers_url)
    end
  end

end
