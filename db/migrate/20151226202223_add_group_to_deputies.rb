class AddGroupToDeputies < ActiveRecord::Migration
  def change
    add_reference :deputies, :group, index: true, foreign_key: true
  end
end
