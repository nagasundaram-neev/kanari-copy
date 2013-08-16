class ModifyRedemptionLog < ActiveRecord::Migration
  def up
    remove_column :redemption_logs, :tablet_id
    add_column    :redemption_logs, :generated_by,  :string
    add_column    :redemption_logs, :redemption_id, :integer
  end
  def down
    remove_column :redemption_logs, :redemption_id
    remove_column :redemption_logs, :generated_by
    add_column    :redemption_logs, :tablet_id, :integer
  end
end
