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
end
