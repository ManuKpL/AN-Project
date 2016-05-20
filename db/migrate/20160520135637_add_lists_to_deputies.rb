class AddListsToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :lists, :json
  end
end
