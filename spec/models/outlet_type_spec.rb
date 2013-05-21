require 'spec_helper'

describe OutletType do
  it { should have_many(:outlets).through(:outlets_outlet_types) }
  it { should have_many(:outlets_outlet_types) }
end
