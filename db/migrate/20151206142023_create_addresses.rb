class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :label
      t.string :description
      t.string :value
      t.string :more_info
      t.string :postcode
      t.string :city
      t.string :phone
      t.string :phone_2
      t.string :fax

      t.timestamps null: false
    end
  end
end
