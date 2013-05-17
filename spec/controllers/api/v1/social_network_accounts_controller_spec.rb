require 'spec_helper'

describe Api::V1::SocialNetworkAccountsController, pending: true do

  # This should return the minimal set of attributes required to create a valid
  # SocialNetworkAccount. As you add validations to SocialNetworkAccount, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "access_token" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SocialNetworkAccountsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all social_network_accounts as @social_network_accounts" do
      social_network_account = SocialNetworkAccount.create! valid_attributes
      get :index, {}, valid_session
      assigns(:social_network_accounts).should eq([social_network_account])
    end
  end

  describe "GET show" do
    it "assigns the requested social_network_account as @social_network_account" do
      social_network_account = SocialNetworkAccount.create! valid_attributes
      get :show, {:id => social_network_account.to_param}, valid_session
      assigns(:social_network_account).should eq(social_network_account)
    end
  end

  describe "GET new" do
    it "assigns a new social_network_account as @social_network_account" do
      get :new, {}, valid_session
      assigns(:social_network_account).should be_a_new(SocialNetworkAccount)
    end
  end

  describe "GET edit" do
    it "assigns the requested social_network_account as @social_network_account" do
      social_network_account = SocialNetworkAccount.create! valid_attributes
      get :edit, {:id => social_network_account.to_param}, valid_session
      assigns(:social_network_account).should eq(social_network_account)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new SocialNetworkAccount" do
        expect {
          post :create, {:social_network_account => valid_attributes}, valid_session
        }.to change(SocialNetworkAccount, :count).by(1)
      end

      it "assigns a newly created social_network_account as @social_network_account" do
        post :create, {:social_network_account => valid_attributes}, valid_session
        assigns(:social_network_account).should be_a(SocialNetworkAccount)
        assigns(:social_network_account).should be_persisted
      end

      it "redirects to the created social_network_account" do
        post :create, {:social_network_account => valid_attributes}, valid_session
        response.should redirect_to(SocialNetworkAccount.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved social_network_account as @social_network_account" do
        # Trigger the behavior that occurs when invalid params are submitted
        SocialNetworkAccount.any_instance.stub(:save).and_return(false)
        post :create, {:social_network_account => { "access_token" => "invalid value" }}, valid_session
        assigns(:social_network_account).should be_a_new(SocialNetworkAccount)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        SocialNetworkAccount.any_instance.stub(:save).and_return(false)
        post :create, {:social_network_account => { "access_token" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested social_network_account" do
        social_network_account = SocialNetworkAccount.create! valid_attributes
        # Assuming there are no other social_network_accounts in the database, this
        # specifies that the SocialNetworkAccount created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        SocialNetworkAccount.any_instance.should_receive(:update).with({ "access_token" => "MyString" })
        put :update, {:id => social_network_account.to_param, :social_network_account => { "access_token" => "MyString" }}, valid_session
      end

      it "assigns the requested social_network_account as @social_network_account" do
        social_network_account = SocialNetworkAccount.create! valid_attributes
        put :update, {:id => social_network_account.to_param, :social_network_account => valid_attributes}, valid_session
        assigns(:social_network_account).should eq(social_network_account)
      end

      it "redirects to the social_network_account" do
        social_network_account = SocialNetworkAccount.create! valid_attributes
        put :update, {:id => social_network_account.to_param, :social_network_account => valid_attributes}, valid_session
        response.should redirect_to(social_network_account)
      end
    end

    describe "with invalid params" do
      it "assigns the social_network_account as @social_network_account" do
        social_network_account = SocialNetworkAccount.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        SocialNetworkAccount.any_instance.stub(:save).and_return(false)
        put :update, {:id => social_network_account.to_param, :social_network_account => { "access_token" => "invalid value" }}, valid_session
        assigns(:social_network_account).should eq(social_network_account)
      end

      it "re-renders the 'edit' template" do
        social_network_account = SocialNetworkAccount.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        SocialNetworkAccount.any_instance.stub(:save).and_return(false)
        put :update, {:id => social_network_account.to_param, :social_network_account => { "access_token" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested social_network_account" do
      social_network_account = SocialNetworkAccount.create! valid_attributes
      expect {
        delete :destroy, {:id => social_network_account.to_param}, valid_session
      }.to change(SocialNetworkAccount, :count).by(-1)
    end

    it "redirects to the social_network_accounts list" do
      social_network_account = SocialNetworkAccount.create! valid_attributes
      delete :destroy, {:id => social_network_account.to_param}, valid_session
      response.should redirect_to(social_network_accounts_url)
    end
  end

end
