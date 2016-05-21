class AddDescriptionToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :description, :text
  end
end
