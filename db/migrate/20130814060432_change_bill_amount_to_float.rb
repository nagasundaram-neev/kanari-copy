class ChangeBillAmountToFloat < ActiveRecord::Migration
  def up
    change_column :feedbacks,            :bill_amount, :float
    change_column :code_generation_logs, :bill_size,   :float
  end
  def down
    change_column :feedbacks,            :bill_amount, :integer
    change_column :code_generation_logs, :bill_size,   :integer
  end
end
