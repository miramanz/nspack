require 'sequel_postgresql_triggers'
Sequel.migration do
  up do
    extension :pg_triggers
    create_table(:rmt_classes, ignore_index_errors: true) do
      primary_key :id
      String :rmt_class_code, null: false
      String :description, null: false
      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
      #
      index [:rmt_class_code], name: :rmt_classes_unique_code, unique: true
    end

    pgt_created_at(:rmt_classes,
                   :created_at,
                   function_name: :rmt_classes_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:rmt_classes,
                   :updated_at,
                   function_name: :rmt_classes_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('rmt_classes', true, true, '{updated_at}'::text[]);"
  end

  down do
    # Drop logging for this table.
    drop_trigger(:rmt_classes, :audit_trigger_row)
    drop_trigger(:rmt_classes, :audit_trigger_stm)

    drop_trigger(:rmt_classes, :set_created_at)
    drop_function(:rmt_classes_set_created_at)
    drop_trigger(:rmt_classes, :set_updated_at)
    drop_function(:rmt_classes_set_updated_at)
    drop_table(:rmt_classes)
  end
end
