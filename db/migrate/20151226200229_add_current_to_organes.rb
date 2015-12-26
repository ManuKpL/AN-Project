class AddCurrentToOrganes < ActiveRecord::Migration
  def change
    add_column :organes, :current, :boolean, default: true
  end
end
