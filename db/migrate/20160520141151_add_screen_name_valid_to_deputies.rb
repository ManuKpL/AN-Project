class AddScreenNameValidToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :screen_name_valid, :boolean
  end
end
