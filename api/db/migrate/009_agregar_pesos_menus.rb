Sequel.migration do
  up do
    add_column :menus, :peso, Integer
  end

  down do
    drop_column :menus, :peso
  end
end
