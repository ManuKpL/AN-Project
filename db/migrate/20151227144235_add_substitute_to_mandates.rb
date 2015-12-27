class AddSubstituteToMandates < ActiveRecord::Migration
  def change
    add_column :mandates, :substitute, :boolean
  end
end
