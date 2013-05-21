class CreateOutletsCuisineTypes < ActiveRecord::Migration
  def change
    create_table :outlets_cuisine_types do |t|
      t.references :outlet, index: true
      t.references :cuisine_type, index: true
    end
  end
end
