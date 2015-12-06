class AddDeputyIdToEAddresses < ActiveRecord::Migration
  def change
    add_reference :e_addresses, :deputy, index: true, foreign_key: true
  end
end
