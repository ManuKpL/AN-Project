class AddTwitterNameToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :twitter_name, :string
  end
end
