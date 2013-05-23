class OutletsOutletType < ActiveRecord::Base
  belongs_to :outlet
  belongs_to :outlet_type
end
