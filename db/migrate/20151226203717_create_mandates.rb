class CreateMandates < ActiveRecord::Migration
  def change
    create_table :mandates do |t|
      t.references :deputy, index: true, foreign_key: true
      t.string :original_tag
      t.string :substitute_original_tag
      t.date :starting_date
      t.string :reason
      t.references :circonscription, index: true, foreign_key: true
      t.integer :seat_num
      t.string :hatvp_page

      t.timestamps null: false
    end
  end
end
