class AddIndexOnCodeToFeedbacks < ActiveRecord::Migration
  def change
    add_index :feedbacks, :code
  end
end
