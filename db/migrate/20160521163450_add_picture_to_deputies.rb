class AddPictureToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :picture, :string
  end
end
