class CreateCirconscriptions < ActiveRecord::Migration
  def change
    create_table :circonscriptions do |t|
      t.string :former_region
      t.string :department
      t.integer :department_num
      t.integer :circo_num

      t.timestamps null: false
    end
  end
end
