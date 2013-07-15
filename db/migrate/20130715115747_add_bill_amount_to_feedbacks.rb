class AddBillAmountToFeedbacks < ActiveRecord::Migration
  def up
    add_column :feedbacks, :bill_amount, :integer
  end

  def down
    remove_column :feedbacks, :bill_amount
  end
end
