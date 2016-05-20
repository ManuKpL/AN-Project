class AddFavouritesToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :favourites, :json
  end
end
