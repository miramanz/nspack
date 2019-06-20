require 'sequel_postgresql_triggers'
Sequel.migration do
  up do
    extension :pg_triggers
    create_table(:zw_packhses, ignore_index_errors: true) do
      primary_key :id
      # String :code, size: 255, null: false
      # TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
      #vhvhvh
      # index [:code], name: :zw_packhses_unique_code, unique: true
    end
    pgt_created_at(:zw_packhses,

                        :created_at,
                   function_name: :zw_packhses_set_created_at,
                        trigger_name: :set_created_at)

    pgt_updated_at(:zw_packhses,
                   :updated_at,
                   function_name: :zw_packhses_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('zw_packhses', true, true, '{updated_at}'::text[]);"
  end

  down do
    # Drop logging for this table.
    drop_trigger(:zw_packhses, :audit_trigger_row)
    drop_trigger(:zw_packhses, :audit_trigger_stm)

    drop_trigger(:zw_packhses, :set_created_at)
    drop_function(:zw_packhses_set_created_at)
    drop_trigger(:zw_packhses, :set_updated_at)
    drop_function(:zw_packhses_set_updated_at)
    drop_table(:zw_packhses)
  end
end
