Sequel.migration do
  up do
    create_table(:calificaciones) do
      primary_key :id
      foreign_key :id_pedido, :pedidos, :on_delete => :cascade
      Integer :puntuacion
    end
  end

  down do
    drop_table(:calificaciones)
  end
end
