class ModifyCodeGenerationLog < ActiveRecord::Migration
  def up
    remove_column :code_generation_logs, :status
    change_column :code_generation_logs, :generated_by, :string
  end
  def down
    add_column    :code_generation_logs, :status,       :string
    change_column :code_generation_logs, :generated_by, :integer
  end
end
