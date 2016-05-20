class AddCreationDateToDeputies < ActiveRecord::Migration
  def change
    add_column :deputies, :creation_date, :datetime
  end
end
