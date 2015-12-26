class CreateFunctions < ActiveRecord::Migration
  def change
    create_table :functions do |t|
      t.string :original_tag
      t.date :starting_date
      t.string :status
      t.string :organe_type
      t.references :deputy, index: true, foreign_key: true
      t.references :organe, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
