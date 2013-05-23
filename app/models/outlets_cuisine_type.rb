class OutletsCuisineType < ActiveRecord::Base
  belongs_to :outlet
  belongs_to :cuisine_type
end
