class CreateECoordinates < ActiveRecord::Migration
  def change
    create_table :e_coordinates do |t|
      t.references :deputy, index: true, foreign_key: true
      t.references :e_address, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
