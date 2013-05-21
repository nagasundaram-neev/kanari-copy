class CreateOutletsStaffs < ActiveRecord::Migration
  def change
    create_table :outlets_staffs do |t|
      t.references :staff, index: true
      t.references :outlet, index: true

      t.timestamps
    end
  end
end
