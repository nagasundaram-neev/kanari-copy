class CuisineType < ActiveRecord::Base
  has_many :outlets_cuisine_types
  has_many :outlets, through: :outlets_cuisine_types
end
