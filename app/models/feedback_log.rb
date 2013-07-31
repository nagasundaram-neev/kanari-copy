class FeedbackLog < ActiveRecord::Base
  scope :user_activities, ->(user) { where(user_id: user.id).order('updated_at desc') }
end
