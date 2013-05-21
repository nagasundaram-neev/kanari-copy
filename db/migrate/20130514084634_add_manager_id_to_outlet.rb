class AddManagerIdToOutlet < ActiveRecord::Migration
  def change
    add_column :outlets, :manager_id, :integer
  end
end
