require 'spec_helper'

describe Outlet do
  it { should belong_to(:customer) }
  it { should have_many(:feedbacks) }
  it { should belong_to(:manager).class_name('User') }
  it { should have_many(:outlets_cuisine_types) }
  it { should have_many(:cuisine_types).through(:outlets_cuisine_types) }
  it { should have_many(:outlets_outlet_types) }
  it { should have_many(:outlet_types).through(:outlets_outlet_types) }
  it { should have_many(:outlets_staffs) }
  it { should have_many(:staffs).through(:outlets_staffs) }
end
