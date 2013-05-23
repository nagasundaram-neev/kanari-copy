require 'spec_helper'

describe CuisineType do
  it { should have_many(:outlets).through(:outlets_cuisine_types) }
  it { should have_many(:outlets_cuisine_types) }
end
