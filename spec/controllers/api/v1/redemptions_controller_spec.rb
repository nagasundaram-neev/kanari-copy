require 'spec_helper'

describe Api::V1::RedemptionsController, pending: true do

  # This should return the minimal set of attributes required to create a valid
  # Redemption. As you add validations to Redemption, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "points" => 100 } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RedemptionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all redemptions as @redemptions" do
      redemption = Redemption.create! valid_attributes
      get :index, {}, valid_session
      assigns(:redemptions).should eq([redemption])
    end
  end

  describe "GET show" do
    it "assigns the requested redemption as @redemption" do
      redemption = Redemption.create! valid_attributes
      get :show, {:id => redemption.to_param}, valid_session
      assigns(:redemption).should eq(redemption)
    end
  end

  describe "GET new" do
    it "assigns a new redemption as @redemption" do
      get :new, {}, valid_session
      assigns(:redemption).should be_a_new(Redemption)
    end
  end

  describe "GET edit" do
    it "assigns the requested redemption as @redemption" do
      redemption = Redemption.create! valid_attributes
      get :edit, {:id => redemption.to_param}, valid_session
      assigns(:redemption).should eq(redemption)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Redemption" do
        expect {
          post :create, {:redemption => valid_attributes}, valid_session
        }.to change(Redemption, :count).by(1)
      end

      it "assigns a newly created redemption as @redemption" do
        post :create, {:redemption => valid_attributes}, valid_session
        assigns(:redemption).should be_a(Redemption)
        assigns(:redemption).should be_persisted
      end

      it "redirects to the created redemption" do
        post :create, {:redemption => valid_attributes}, valid_session
        response.should redirect_to(Redemption.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved redemption as @redemption" do
        # Trigger the behavior that occurs when invalid params are submitted
        Redemption.any_instance.stub(:save).and_return(false)
        post :create, {:redemption => { "user" => "invalid value" }}, valid_session
        assigns(:redemption).should be_a_new(Redemption)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Redemption.any_instance.stub(:save).and_return(false)
        post :create, {:redemption => { "user" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested redemption" do
        redemption = Redemption.create! valid_attributes
        # Assuming there are no other redemptions in the database, this
        # specifies that the Redemption created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Redemption.any_instance.should_receive(:update).with({ "points" => "100" })
        put :update, {:id => redemption.to_param, :redemption => { "points" => 100 }}, valid_session
      end

      it "assigns the requested redemption as @redemption" do
        redemption = Redemption.create! valid_attributes
        put :update, {:id => redemption.to_param, :redemption => valid_attributes}, valid_session
        assigns(:redemption).should eq(redemption)
      end

      it "redirects to the redemption" do
        redemption = Redemption.create! valid_attributes
        put :update, {:id => redemption.to_param, :redemption => valid_attributes}, valid_session
        response.should redirect_to(redemption)
      end
    end

    describe "with invalid params" do
      it "assigns the redemption as @redemption" do
        redemption = Redemption.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Redemption.any_instance.stub(:save).and_return(false)
        put :update, {:id => redemption.to_param, :redemption => { "user" => "invalid value" }}, valid_session
        assigns(:redemption).should eq(redemption)
      end

      it "re-renders the 'edit' template" do
        redemption = Redemption.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Redemption.any_instance.stub(:save).and_return(false)
        put :update, {:id => redemption.to_param, :redemption => { "user" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested redemption" do
      redemption = Redemption.create! valid_attributes
      expect {
        delete :destroy, {:id => redemption.to_param}, valid_session
      }.to change(Redemption, :count).by(-1)
    end

    it "redirects to the redemptions list" do
      redemption = Redemption.create! valid_attributes
      delete :destroy, {:id => redemption.to_param}, valid_session
      response.should redirect_to(redemptions_url)
    end
  end

end
