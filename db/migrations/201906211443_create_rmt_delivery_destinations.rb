require 'sequel_postgresql_triggers'
Sequel.migration do
  up do
    extension :pg_triggers
    create_table(:rmt_delivery_destinations, ignore_index_errors: true) do
      primary_key :id
      String :delivery_destination_code, null: false
      String :description
      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:delivery_destination_code], name: :rmt_delivery_destinations_unique_code, unique: true
    end

    pgt_created_at(:rmt_delivery_destinations,
                   :created_at,
                   function_name: :rmt_delivery_destinations_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:rmt_delivery_destinations,
                   :updated_at,
                   function_name: :rmt_delivery_destinations_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('rmt_delivery_destinations', true, true, '{updated_at}'::text[]);"
  end

  down do
    # Drop logging for this table.
    drop_trigger(:rmt_delivery_destinations, :audit_trigger_row)
    drop_trigger(:rmt_delivery_destinations, :audit_trigger_stm)

    drop_trigger(:rmt_delivery_destinations, :set_created_at)
    drop_function(:rmt_delivery_destinations_set_created_at)
    drop_trigger(:rmt_delivery_destinations, :set_updated_at)
    drop_function(:rmt_delivery_destinations_set_updated_at)
    drop_table(:rmt_delivery_destinations)
  end
end
