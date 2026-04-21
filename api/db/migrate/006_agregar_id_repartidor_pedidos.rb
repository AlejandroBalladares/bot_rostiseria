Sequel.migration do
  up do
    add_column :pedidos, :id_repartidor, Integer, :references => :repartidores
  end

  down do
    drop_column :pedidos, :id_repartidor
  end
end
