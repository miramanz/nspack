require 'sequel_postgresql_triggers'
Sequel.migration do
  up do
    extension :pg_triggers
    create_table(:pucs, ignore_index_errors: true) do
      primary_key :id
      String :puc_code, size: 255, null: false
      String :gap_code
      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:puc_code], name: :pucs_unique_code, unique: true
    end

    pgt_created_at(:pucs,
                   :created_at,
                   function_name: :pucs_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:pucs,
                   :updated_at,
                   function_name: :pucs_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('pucs', true, true, '{updated_at}'::text[]);"
  end

  down do
    # Drop logging for this table.
    drop_trigger(:pucs, :audit_trigger_row)
    drop_trigger(:pucs, :audit_trigger_stm)

    drop_trigger(:pucs, :set_created_at)
    drop_function(:pucs_set_created_at)
    drop_trigger(:pucs, :set_updated_at)
    drop_function(:pucs_set_updated_at)
    drop_table(:pucs)
  end
end
