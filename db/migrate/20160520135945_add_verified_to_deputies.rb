class AddVerifiedToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :verified, :boolean
  end
end
