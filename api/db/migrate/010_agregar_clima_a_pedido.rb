Sequel.migration do
  up do
    add_column :pedidos, :lloviendo, FalseClass, default: false
  end

  down do
    drop_column :pedidos, :lloviendo
  end
end
