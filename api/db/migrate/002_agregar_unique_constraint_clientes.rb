Sequel.migration do
  up do
    alter_table(:clientes) do
      add_unique_constraint(:id_telegram, name: :unique_id_telegram)
    end
  end

  down do
    alter_table(:clientes) do
      drop_constraint(:unique_id_telegram)
    end
  end
end
