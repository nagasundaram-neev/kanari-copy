class SetDefaultCompletedFeedback < ActiveRecord::Migration
  def up
    change_column :feedbacks, :completed, :boolean, :default => false
  end

  def down
    change_column :feedbacks, :completed, :boolean, :default => true
  end
end
