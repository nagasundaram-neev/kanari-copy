class Feedback < ActiveRecord::Base
  belongs_to :user, inverse_of: :feedbacks
  belongs_to :outlet, inverse_of: :feedbacks
end
