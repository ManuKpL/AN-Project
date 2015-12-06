class AddOriginalTagToDeputy < ActiveRecord::Migration
  def change
    add_column :deputies, :original_tag, :string
  end
end
