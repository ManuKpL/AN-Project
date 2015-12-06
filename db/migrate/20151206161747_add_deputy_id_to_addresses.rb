class AddDeputyIdToAddresses < ActiveRecord::Migration
  def change
    add_reference :addresses, :deputy, index: true, foreign_key: true
  end
end
