require 'spec_helper'

describe OutletsCuisineType do
  it { should belong_to(:outlet) }
  it { should belong_to(:cuisine_type) }
end
