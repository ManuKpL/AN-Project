class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :sigle
      t.references :organe, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
