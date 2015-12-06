class CreateDeputies < ActiveRecord::Migration
  def change
    create_table :deputies do |t|
      t.string :civ
      t.string :firstname
      t.string :lastname
      t.date :birthday
      t.string :birthdep
      t.references :job, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
