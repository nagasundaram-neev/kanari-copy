class AddDisabledToOutlets < ActiveRecord::Migration
  def change
    add_column :outlets, :disabled, :boolean, default: false
  end
end
