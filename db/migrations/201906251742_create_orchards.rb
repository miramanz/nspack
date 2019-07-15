require 'sequel_postgresql_triggers'
Sequel.migration do
  up do
    extension :pg_triggers
    create_table(:orchards, ignore_index_errors: true) do
      primary_key :id
      foreign_key :farm_id, :farms, type: :integer, null: false
      foreign_key :puc_id, :pucs, type: :integer, null: false
      String :orchard_code, size: 255, null: false
      String :description
      column :cultivars, 'int[]'
      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:orchard_code], name: :orchards_unique_code, unique: true
    end

    pgt_created_at(:orchards,
                   :created_at,
                   function_name: :orchards_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:orchards,
                   :updated_at,
                   function_name: :orchards_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('orchards', true, true, '{updated_at}'::text[]);"
  end

  down do
    # Drop logging for this table.
    drop_trigger(:orchards, :audit_trigger_row)
    drop_trigger(:orchards, :audit_trigger_stm)

    drop_trigger(:orchards, :set_created_at)
    drop_function(:orchards_set_created_at)
    drop_trigger(:orchards, :set_updated_at)
    drop_function(:orchards_set_updated_at)
    drop_table(:orchards)
  end
end
