require 'spec_helper'

describe OutletsOutletType do
  it { should belong_to(:outlet) }
  it { should belong_to(:outlet_type) }
end
