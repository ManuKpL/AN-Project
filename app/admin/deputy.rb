ActiveAdmin.register Deputy do
  permit_params :civ, :firstname, :lastname, :birthday, :birthdep, :original_tag, :job_id, :screen_name

  index do
    selectable_column
    column :id
    column :civ
    column :firstname
    column :lastname
    column :screen_name
    column :original_tag
    column :job
    column :updated_at
    actions
  end
end
