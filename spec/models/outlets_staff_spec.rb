require 'spec_helper'

describe OutletsStaff do
  it { should belong_to(:staff) }
  it { should belong_to(:outlet) }
end
