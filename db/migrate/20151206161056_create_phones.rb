class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :label
      t.string :value
      t.references :address, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
