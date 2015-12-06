class RemoveFaxFromAddresses < ActiveRecord::Migration
  def change
    remove_column :addresses, :fax, :string
  end
end
