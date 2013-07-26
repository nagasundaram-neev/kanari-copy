class AddLastActivityAtAndFeedbackCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :feedbacks_count,  :integer
    add_column :users, :last_activity_at, :datetime
  end
end
