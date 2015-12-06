class RemovePhone2FromAddresses < ActiveRecord::Migration
  def change
    remove_column :addresses, :phone_2, :string
  end
end
