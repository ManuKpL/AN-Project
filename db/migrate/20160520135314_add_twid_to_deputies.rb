class AddTwidToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :twid, :string
  end
end
