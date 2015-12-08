class AddScreenNameToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :screen_name, :string
  end
end
