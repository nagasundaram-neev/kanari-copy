class CreateGlobalSettings < ActiveRecord::Migration
  def change
    create_table :global_settings do |t|
      t.string :setting_name
      t.string :setting_value
    end
  end
end
