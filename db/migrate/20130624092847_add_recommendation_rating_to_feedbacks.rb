class AddRecommendationRatingToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :recommendation_rating, :integer
  end
end
