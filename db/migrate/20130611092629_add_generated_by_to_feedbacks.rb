class AddGeneratedByToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :generated_by, :integer
  end
end
