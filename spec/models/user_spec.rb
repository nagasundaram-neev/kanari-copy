require 'spec_helper'

describe User do
  it { should have_many(:feedbacks) }
  it { should have_many(:managed_outlets) }
  it { should have_one(:outlets_staff) }
  it { should have_one(:employed_outlet).through(:outlets_staff) }
end
