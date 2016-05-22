class AddFollowersToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :followers, :json
  end
end
