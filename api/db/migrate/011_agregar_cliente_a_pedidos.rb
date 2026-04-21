Sequel.migration do
  up do
    add_column :pedidos, :id_cliente, Integer
  end

  down do
    drop_column :pedidos, :id_cliente
  end
end
