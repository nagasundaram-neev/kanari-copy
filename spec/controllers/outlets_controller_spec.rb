require 'spec_helper'

describe OutletsController, pending: true do

  # This should return the minimal set of attributes required to create a valid
  # Outlet. As you add validations to Outlet, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "name" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OutletsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all outlets as @outlets" do
      outlet = Outlet.create! valid_attributes
      get :index, {}, valid_session
      assigns(:outlets).should eq([outlet])
    end
  end

  describe "GET show" do
    it "assigns the requested outlet as @outlet" do
      outlet = Outlet.create! valid_attributes
      get :show, {:id => outlet.to_param}, valid_session
      assigns(:outlet).should eq(outlet)
    end
  end

  describe "GET new" do
    it "assigns a new outlet as @outlet" do
      get :new, {}, valid_session
      assigns(:outlet).should be_a_new(Outlet)
    end
  end

  describe "GET edit" do
    it "assigns the requested outlet as @outlet" do
      outlet = Outlet.create! valid_attributes
      get :edit, {:id => outlet.to_param}, valid_session
      assigns(:outlet).should eq(outlet)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Outlet" do
        expect {
          post :create, {:outlet => valid_attributes}, valid_session
        }.to change(Outlet, :count).by(1)
      end

      it "assigns a newly created outlet as @outlet" do
        post :create, {:outlet => valid_attributes}, valid_session
        assigns(:outlet).should be_a(Outlet)
        assigns(:outlet).should be_persisted
      end

      it "redirects to the created outlet" do
        post :create, {:outlet => valid_attributes}, valid_session
        response.should redirect_to(Outlet.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved outlet as @outlet" do
        # Trigger the behavior that occurs when invalid params are submitted
        Outlet.any_instance.stub(:save).and_return(false)
        post :create, {:outlet => { "name" => "invalid value" }}, valid_session
        assigns(:outlet).should be_a_new(Outlet)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Outlet.any_instance.stub(:save).and_return(false)
        post :create, {:outlet => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested outlet" do
        outlet = Outlet.create! valid_attributes
        # Assuming there are no other outlets in the database, this
        # specifies that the Outlet created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Outlet.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => outlet.to_param, :outlet => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested outlet as @outlet" do
        outlet = Outlet.create! valid_attributes
        put :update, {:id => outlet.to_param, :outlet => valid_attributes}, valid_session
        assigns(:outlet).should eq(outlet)
      end

      it "redirects to the outlet" do
        outlet = Outlet.create! valid_attributes
        put :update, {:id => outlet.to_param, :outlet => valid_attributes}, valid_session
        response.should redirect_to(outlet)
      end
    end

    describe "with invalid params" do
      it "assigns the outlet as @outlet" do
        outlet = Outlet.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Outlet.any_instance.stub(:save).and_return(false)
        put :update, {:id => outlet.to_param, :outlet => { "name" => "invalid value" }}, valid_session
        assigns(:outlet).should eq(outlet)
      end

      it "re-renders the 'edit' template" do
        outlet = Outlet.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Outlet.any_instance.stub(:save).and_return(false)
        put :update, {:id => outlet.to_param, :outlet => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested outlet" do
      outlet = Outlet.create! valid_attributes
      expect {
        delete :destroy, {:id => outlet.to_param}, valid_session
      }.to change(Outlet, :count).by(-1)
    end

    it "redirects to the outlets list" do
      outlet = Outlet.create! valid_attributes
      delete :destroy, {:id => outlet.to_param}, valid_session
      response.should redirect_to(outlets_url)
    end
  end

end
