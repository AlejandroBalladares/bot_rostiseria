Sequel.migration do
  up do
    create_table(:repartidores) do
      primary_key :id
      Integer :documento
      String :nombre
    end
  end

  down do
    drop_table(:pedidos)
  end
end
