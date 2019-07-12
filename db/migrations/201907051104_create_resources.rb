require 'sequel_postgresql_triggers'
Sequel.migration do
  up do
    extension :pg_triggers
    extension :pg_json

    # RESOURCE TYPES
    # --------------
    create_table(:resource_types, ignore_index_errors: true) do
      primary_key :id
      String :resource_type_code, null: false
      String :description, null: false
      TrueClass :system_resource, default: false # ok for indexing? - with id?
      Jsonb :attribute_rules
      Jsonb :behaviour_rules
      String :icon

      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:resource_type_code], name: :resource_types_unique_code, unique: true
    end

    pgt_created_at(:resource_types,
                   :created_at,
                   function_name: :resource_types_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:resource_types,
                   :updated_at,
                   function_name: :resource_types_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('resource_types', true, true, '{updated_at}'::text[]);"

    # RESOURCES
    # ---------
    create_table(:resources, ignore_index_errors: true) do
      primary_key :id
      foreign_key :resource_type_id, :resource_types, type: :integer, null: false
      foreign_key :system_resource_id, :resources, type: :integer
      String :resource_code, null: false
      String :description, null: false
      Jsonb :resource_attributes

      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:resource_code], name: :resources_unique_code, unique: true
    end

    pgt_created_at(:resources,
                   :created_at,
                   function_name: :resources_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:resources,
                   :updated_at,
                   function_name: :resources_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('resources', true, true, '{updated_at}'::text[]);"

    # PLANT SYSTEM RESOURCES
    # ----------------------
    create_table(:plant_system_resources, ignore_index_errors: true) do
      foreign_key :plant_resource_id, :resources, null: false, key: [:id]
      foreign_key :system_resource_id, :resources, null: false, key: [:id]
      
      primary_key [:plant_resource_id, :system_resource_id], name: :plant_system_resources_pk
    end

    # TREE RESOURCES
    # --------------
    create_table(:tree_resources, ignore_index_errors: true) do
      foreign_key :ancestor_resource_id, :resources, null: false, key: [:id]
      foreign_key :descendant_resource_id, :resources, null: false, key: [:id]
      Integer :path_length
      
      primary_key [:ancestor_resource_id, :descendant_resource_id], name: :tree_resources_pk
    end
  end

  down do
    drop_table(:tree_resources)

    drop_table(:plant_system_resources)

    # Drop logging for resources.
    drop_trigger(:resources, :audit_trigger_row)
    drop_trigger(:resources, :audit_trigger_stm)

    drop_trigger(:resources, :set_created_at)
    drop_function(:resources_set_created_at)
    drop_trigger(:resources, :set_updated_at)
    drop_function(:resources_set_updated_at)
    drop_table(:resources)

    # Drop logging for resource_types.
    drop_trigger(:resource_types, :audit_trigger_row)
    drop_trigger(:resource_types, :audit_trigger_stm)

    drop_trigger(:resource_types, :set_created_at)
    drop_function(:resource_types_set_created_at)
    drop_trigger(:resource_types, :set_updated_at)
    drop_function(:resource_types_set_updated_at)
    drop_table(:resource_types)
  end
end
