class CreateEAddresses < ActiveRecord::Migration
  def change
    create_table :e_addresses do |t|
      t.string :label
      t.string :value

      t.timestamps null: false
    end
  end
end
