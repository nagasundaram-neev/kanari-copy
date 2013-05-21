class OutletsStaff < ActiveRecord::Base
  belongs_to :staff, class_name: 'User'
  belongs_to :outlet
end
