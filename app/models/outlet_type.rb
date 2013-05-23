class OutletType < ActiveRecord::Base
  has_many :outlets_outlet_types
  has_many :outlets, through: :outlets_outlet_types
end
