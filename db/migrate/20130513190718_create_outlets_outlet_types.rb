class CreateOutletsOutletTypes < ActiveRecord::Migration
  def change
    create_table :outlets_outlet_types do |t|
      t.references :outlet, index: true
      t.references :outlet_type, index: true
    end
  end
end
