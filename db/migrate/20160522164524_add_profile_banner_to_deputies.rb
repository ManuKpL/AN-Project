class AddProfileBannerToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :profile_banner, :string
  end
end
