class AddOriginalTagToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :original_tag, :string
  end
end
