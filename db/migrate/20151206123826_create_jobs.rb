class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :label
      t.string :category
      t.string :family

      t.timestamps null: false
    end
  end
end
