class AddProfilePictureToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :profile_picture, :string
  end
end
