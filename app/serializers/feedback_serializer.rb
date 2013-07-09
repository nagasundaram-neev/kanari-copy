class FeedbackSerializer < ActiveModel::Serializer
  attributes :id, :food_quality, :speed_of_service, :friendliness_of_service, :ambience, :cleanliness, :value_for_money, :comment, :updated_at, :promoter_score, :points

  def promoter_score
    object.recommendation_rating
  end

end
