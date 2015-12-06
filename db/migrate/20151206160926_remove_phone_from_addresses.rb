class RemovePhoneFromAddresses < ActiveRecord::Migration
  def change
    remove_column :addresses, :phone, :string
  end
end
