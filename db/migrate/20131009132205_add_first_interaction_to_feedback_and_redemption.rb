class AddFirstInteractionToFeedbackAndRedemption < ActiveRecord::Migration
  def change
    add_column :feedbacks, :first_interaction, :boolean, default: false
    add_column :redemptions, :first_interaction, :boolean, default: false
  end
end
