class Feedback < ActiveRecord::Base
  belongs_to :user, inverse_of: :feedbacks
  belongs_to :outlet, inverse_of: :feedbacks
  belongs_to :staff, class_name: 'User', foreign_key: 'generated_by'

  scope :completed,       ->             { where(completed: true) }

  scope :promoters,       ->             { where(completed: true, recommendation_rating: 9..10)}
  scope :passives,        ->             { where(completed: true, recommendation_rating: 7..8) }
  scope :neutrals,        ->             { where(completed: true, recommendation_rating: 0..6) }

  scope :field_promoters, ->(field_name) { where(:completed => true, field_name.to_sym =>  1 ) }
  scope :field_passives,  ->(field_name) { where(:completed => true, field_name.to_sym => -1 ) }
  scope :field_neutrals,  ->(field_name) { where(:completed => true, field_name.to_sym =>  0 ) }

  scope :by_date,         ->(datetime)   { where(completed: true, updated_at: datetime.beginning_of_day..datetime.end_of_day ) }
  scope :limit_results,   ->(limit)      { limit(limit) }
end
