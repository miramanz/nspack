require 'sequel_postgresql_triggers'
Sequel.migration do
  up do
    extension :pg_triggers
    create_table(:farms, ignore_index_errors: true) do
      primary_key :id
      foreign_key :owner_party_role_id, :party_roles, type: :integer, null: false
      foreign_key :pdn_region_id, :production_regions, type: :integer, null: false
      foreign_key :farm_group_id, :farm_groups, type: :integer, null: false
      String :farm_code, size: 255, null: false
      String :description
      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:farm_code], name: :farms_unique_code, unique: true
    end

    pgt_created_at(:farms,
                   :created_at,
                   function_name: :farms_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:farms,
                   :updated_at,
                   function_name: :farms_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('farms', true, true, '{updated_at}'::text[]);"
  end

  down do
    # Drop logging for this table.
    drop_trigger(:farms, :audit_trigger_row)
    drop_trigger(:farms, :audit_trigger_stm)

    drop_trigger(:farms, :set_created_at)
    drop_function(:farms_set_created_at)
    drop_trigger(:farms, :set_updated_at)
    drop_function(:farms_set_updated_at)
    drop_table(:farms)
  end
end
