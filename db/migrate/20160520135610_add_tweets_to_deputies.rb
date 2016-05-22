class AddTweetsToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :tweets, :json
  end
end
