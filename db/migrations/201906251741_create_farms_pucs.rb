require 'sequel_postgresql_triggers'
Sequel.migration do
  up do
    extension :pg_triggers
    create_table(:farms_pucs, ignore_index_errors: true) do
      primary_key :id
      foreign_key :puc_id, :pucs, type: :integer, null: false
      foreign_key :farm_id, :farms, type: :integer, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
      #
      # index [:code], name: :farms_pucs_unique_code, unique: true
    end

    pgt_created_at(:farms_pucs,
                   :created_at,
                   function_name: :farms_pucs_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:farms_pucs,
                   :updated_at,
                   function_name: :farms_pucs_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('farms_pucs', true, true, '{updated_at}'::text[]);"
  end

  down do
    # Drop logging for this table.
    drop_trigger(:farms_pucs, :audit_trigger_row)
    drop_trigger(:farms_pucs, :audit_trigger_stm)

    drop_trigger(:farms_pucs, :set_created_at)
    drop_function(:farms_pucs_set_created_at)
    drop_trigger(:farms_pucs, :set_updated_at)
    drop_function(:farms_pucs_set_updated_at)
    drop_table(:farms_pucs)
  end
end
