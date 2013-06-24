class RemoveWillRecommendFromFeedbacks < ActiveRecord::Migration
  def change
    remove_column :feedbacks, :will_recommend
  end
end
