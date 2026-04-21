Sequel.migration do
  up do
    create_table(:pedidos) do
      primary_key :id
      Integer :id_menu
    end
  end

  down do
    drop_table(:pedidos)
  end
end
