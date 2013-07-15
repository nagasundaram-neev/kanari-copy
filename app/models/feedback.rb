class Feedback < ActiveRecord::Base
  belongs_to :user, inverse_of: :feedbacks
  belongs_to :outlet, inverse_of: :feedbacks
  belongs_to :staff, class_name: 'User', foreign_key: 'generated_by'

  scope :completed, -> { where(completed: true) }
  scope :pending,   -> { where(completed: nil || false) }
end
