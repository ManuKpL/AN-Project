class AddCurrentToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :current, :boolean
  end
end
