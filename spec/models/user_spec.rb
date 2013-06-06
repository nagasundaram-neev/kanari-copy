require 'spec_helper'

describe User do
  it { should have_many(:feedbacks) }
  it { should have_many(:managed_outlets) }
  it { should have_one(:outlets_staff) }
  it { should have_one(:employed_outlet).through(:outlets_staff) }

  shared_examples "a user who has a customer account" do
    it "should return the customer" do
      user.customer.should == customer
    end
  end

  describe "#customer" do
    let(:customer) { FactoryGirl.create(:customer) }
    context "when the user is under a customer account" do
      describe "when the user is a customer_admin" do
        let(:user) do
          user = FactoryGirl.create(:user, role: 'customer_admin')
          customer.customer_admin = user
          customer.save
          return user
        end
        #customer.customer_admin = user
        #customer.save
        it_should_behave_like "a user who has a customer account"
      end
      describe "when the user is a manager" do
        let(:user) { FactoryGirl.create(:user, role: 'manager') }
        let!(:outlet) { FactoryGirl.create(:outlet, customer: customer, manager: user)  }
        it_should_behave_like "a user who has a customer account"
      end
      describe "when the user is a staff" do
        let(:outlet) { FactoryGirl.create(:outlet, customer: customer)  }
        let(:user) { FactoryGirl.create(:user, employed_outlet: outlet, role: 'staff') }
        it_should_behave_like "a user who has a customer account"
      end
    end
    context "when the user does not have a customer account" do
      context "when the user is an end user" do
        it "should return nil" do
          user = FactoryGirl.create(:user)
          user.customer.should be_nil
        end
      end
    end
  end

  describe "#outlets" do
    let(:user) { FactoryGirl.create(:user, role: role)}
    context "when role is kanari_admin" do
      let(:role) { 'kanari_admin' }
      it "should return all the outlets in the database" do
        customer = FactoryGirl.create(:customer)
        another_customer = FactoryGirl.create(:customer)
        outlet_1 = FactoryGirl.create(:outlet, customer: customer)
        outlet_2 = FactoryGirl.create(:outlet, customer: customer)
        outlet_3 = FactoryGirl.create(:outlet, customer: another_customer)
        user.outlets.should =~ [outlet_1, outlet_2, outlet_3]
      end
    end
    context "when role is customer_admin" do
      let(:role) { 'customer_admin' }
      it "should return all the outlets belonging to the customer" do
        customer = FactoryGirl.create(:customer, customer_admin: user)
        another_customer = FactoryGirl.create(:customer)
        outlet_1 = FactoryGirl.create(:outlet, customer: customer)
        outlet_2 = FactoryGirl.create(:outlet, customer: customer)
        outlet_3 = FactoryGirl.create(:outlet, customer: another_customer)
        user.outlets.should =~ [outlet_1, outlet_2]
      end
      context "when there is no customer account created" do
        it "should return an empty array" do
          user.outlets.should == []
        end
      end
    end
    context "when role is manager" do
      let(:role) { 'manager' }
      it "should return all the outlets managed by the user" do
        customer = FactoryGirl.create(:customer)
        another_customer = FactoryGirl.create(:customer)
        outlet_1 = FactoryGirl.create(:outlet, customer: customer, manager: user)
        outlet_2 = FactoryGirl.create(:outlet, customer: customer, manager: user)
        outlet_3 = FactoryGirl.create(:outlet, customer: another_customer)
        user.outlets.should =~ [outlet_1, outlet_2]
      end
    end
    context "when role is staff" do
      let(:role) { 'staff' }
      it "should return the outlet where the user is employed" do
        customer = FactoryGirl.create(:customer)
        another_customer = FactoryGirl.create(:customer)
        outlet_1 = FactoryGirl.create(:outlet, customer: customer, staffs: [user])
        outlet_2 = FactoryGirl.create(:outlet, customer: customer)
        outlet_3 = FactoryGirl.create(:outlet, customer: another_customer)
        user.outlets.should =~ [outlet_1]
      end
    end
    context "when role is user" do
      let(:role) { 'user' }
      it "should return an empty array" do
        user.outlets.should == []
      end
    end
    context "when role is invalid" do
      let(:role) { 'random' }
      it "should return an empty array" do
        user.outlets.should == []
      end
    end
  end

  describe "#registration_complete?" do
    let(:user) { FactoryGirl.create(:user, role: role)}
    context "when role is kanari_admin" do
      let(:role) { 'kanari_admin' }
      it "should be true" do
        user.registration_complete?.should be_true
      end
    end
    context "when role is customer_admin" do
      let(:role) { 'customer_admin' }
      context "when a customer account is present" do
        it "should be true" do
          customer = FactoryGirl.create(:customer, customer_admin: user)
          user.registration_complete?.should be_true
        end
      end
      context "when a customer account is not present" do
        it "should be false" do
          user.registration_complete?.should be_false
        end
      end
    end
    context "when role is manager" do
      let(:role) { 'manager' }
      it "should be true" do
        user.registration_complete?.should be_true
      end
    end
    context "when role is staff" do
      let(:role) { 'staff' }
      it "should be true" do
        user.registration_complete?.should be_true
      end
    end
    context "when role is user" do
      let(:role) { 'user' }
      it "should be true" do
        user.registration_complete?.should be_true
      end
    end
    context "when role is invalid" do
      let(:role) { 'random' }
      it "should be true" do
        user.registration_complete?.should be_true
      end
    end
  end
end
