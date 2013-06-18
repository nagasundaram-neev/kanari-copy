class Redemption < ActiveRecord::Base
  belongs_to :user, inverse_of: :redemptions
  belongs_to :outlet, inverse_of: :redemptions
  belongs_to :staff, class_name: 'User', foreign_key: 'approved_by'
end
