class Feedback < ActiveRecord::Base
  belongs_to :user, inverse_of: :feedbacks
  belongs_to :outlet, inverse_of: :feedbacks
  belongs_to :staff, class_name: 'User', foreign_key: 'generated_by'

  scope :completed,    -> { where(completed: true) }
  scope :notcompleted, -> { where(completed: false) }
  scope :active,       -> {
    expiry_time = GlobalSetting.where(setting_name: 'feedback_expiry_time').first.setting_value.to_i rescue 120
    where("created_at > ?", Time.zone.now - expiry_time.minutes )
  }
  scope :pending,     -> { active.notcompleted }
  scope :processed,   -> {
    expiry_time = GlobalSetting.where(setting_name: 'feedback_expiry_time').first.setting_value.to_i rescue 120
    where("created_at <= ? OR completed = ?", Time.zone.now - expiry_time.minutes, true )
  }

  delegate :name, :to => :outlet
end
