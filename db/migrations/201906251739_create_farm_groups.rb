require 'sequel_postgresql_triggers'
Sequel.migration do
  up do
    extension :pg_triggers
    create_table(:farm_groups, ignore_index_errors: true) do
      primary_key :id
      foreign_key :owner_party_role_id, :party_roles, type: :integer, null: false
      String :farm_group_code, size: 255, null: false
      String :description
      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:farm_group_code], name: :farm_groups_unique_code, unique: true
    end

    pgt_created_at(:farm_groups,
                   :created_at,
                   function_name: :farm_groups_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:farm_groups,
                   :updated_at,
                   function_name: :farm_groups_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('farm_groups', true, true, '{updated_at}'::text[]);"
  end

  down do
    # Drop logging for this table.
    drop_trigger(:farm_groups, :audit_trigger_row)
    drop_trigger(:farm_groups, :audit_trigger_stm)

    drop_trigger(:farm_groups, :set_created_at)
    drop_function(:farm_groups_set_created_at)
    drop_trigger(:farm_groups, :set_updated_at)
    drop_function(:farm_groups_set_updated_at)
    drop_table(:farm_groups)
  end
end
