class CreateOrganes < ActiveRecord::Migration
  def change
    create_table :organes do |t|
      t.string :original_tag
      t.string :label

      t.timestamps null: false
    end
  end
end
