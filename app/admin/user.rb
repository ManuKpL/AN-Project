ActiveAdmin.register User do
  permit_params :name, :email, :admin

  index do
    selectable_column
    column :id
    column :email
    column :created_at
    column :admin
    actions
  end

  form do |f|
    f.inputs "Identity" do
      f.input :email
    end
    f.inputs "Admin" do
      f.input :admin
    end
    f.actions
  end
end
