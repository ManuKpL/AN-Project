class AddFollowingsToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :followings, :json
  end
end
