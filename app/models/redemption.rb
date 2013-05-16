class Redemption < ActiveRecord::Base
  belongs_to :user
  belongs_to :outlet
  belongs_to :staff, class_name: 'User', foreign_key: 'approved_by'
end
