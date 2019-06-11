Sequel.migration do
  up do
    alter_table(:location_storage_types) do
      add_column :location_short_code_prefix, String
    end
  end

  down do
    alter_table(:location_storage_types) do
      drop_column :location_short_code_prefix
    end
  end
end
