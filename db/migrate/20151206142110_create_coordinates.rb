class CreateCoordinates < ActiveRecord::Migration
  def change
    create_table :coordinates do |t|
      t.references :deputy, index: true, foreign_key: true
      t.references :address, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
