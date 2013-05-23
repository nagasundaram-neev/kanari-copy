class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :code
      t.integer :food_quality
      t.integer :speed_of_service
      t.integer :friendliness_of_service
      t.integer :ambience
      t.integer :cleanliness
      t.integer :value_for_money
      t.text :comment
      t.boolean :will_recommend
      t.boolean :completed
      t.integer :points
      t.integer :rewards_pool_after_feedback
      t.integer :user_points_after_feedback
      t.references :user, index: true
      t.references :outlet, index: true

      t.timestamps
    end
  end
end
