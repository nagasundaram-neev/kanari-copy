class CreateCodeGenerationLog < ActiveRecord::Migration
  def change
    create_table :code_generation_logs do |t|
      t.integer   :outlet_id
      t.string    :outlet_name
      t.integer   :customer_id
      t.integer   :generated_by
      t.integer   :feedback_id
      t.string    :code
      t.integer   :bill_size
      t.string    :status
      t.timestamps
    end
  end
end
