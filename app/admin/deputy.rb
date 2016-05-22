ActiveAdmin.register Deputy do
  permit_params :civ, :firstname, :lastname, :birthday, :birthdep, :original_tag, :job_id, :screen_name, :screen_name_valid

  index do
    selectable_column
    column :id
    column :civ
    column :firstname
    column :lastname
    column :screen_name
    column :screen_name_valid
    column :original_tag
    column :job
    column :updated_at
    actions
  end


  form do |f|
    f.inputs "Identity" do
      f.input :civ
      f.input :firstname
      f.input :lastname
    end
    f.inputs "Data AN" do
      f.input :original_tag
      f.input :picture
    end
    f.inputs "Twitter" do
      f.input :screen_name
      f.input :screen_name_valid
    end
    f.actions
  end
end
