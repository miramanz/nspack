require 'sequel_postgresql_triggers'
Sequel.migration do
  up do
    extension :pg_triggers
    extension :pg_json
    # plant_resource_types ++ system_resource_types???

    # SYSTEM RESOURCE TYPES
    # ---------------------
    create_table(:system_resource_types, ignore_index_errors: true) do
      primary_key :id
      String :system_resource_type_code, null: false
      String :description, null: false
      # TrueClass :system_resource, default: false
      # TrueClass :computing_device, default: false
      # TrueClass :peripheral, default: false
      # Jsonb :attribute_rules
      # Jsonb :behaviour_rules
      String :icon

      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:system_resource_type_code], name: :system_resource_types_unique_code, unique: true
    end

    pgt_created_at(:system_resource_types,
                   :created_at,
                   function_name: :system_resource_types_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:system_resource_types,
                   :updated_at,
                   function_name: :system_resource_types_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('system_resource_types', true, true, '{updated_at}'::text[]);"

    # PLANT RESOURCE TYPES
    # --------------------
    create_table(:plant_resource_types, ignore_index_errors: true) do
      primary_key :id
      String :plant_resource_type_code, null: false
      String :description, null: false
      # TrueClass :system_resource, default: false
      # TrueClass :computing_device, default: false
      # TrueClass :peripheral, default: false
      # Jsonb :attribute_rules
      # Jsonb :behaviour_rules
      String :icon

      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:plant_resource_type_code], name: :plant_resource_types_unique_code, unique: true
    end

    pgt_created_at(:plant_resource_types,
                   :created_at,
                   function_name: :plant_resource_types_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:plant_resource_types,
                   :updated_at,
                   function_name: :plant_resource_types_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('plant_resource_types', true, true, '{updated_at}'::text[]);"

    # system resources: computing device / peripheral
    # computing_device_id XXX : can belong to > 1
    # peripheral_type       | = resource_type
    # computing_device_type | = resource_type
    # peripheral?
    # computing_device?

    # SYSTEM RESOURCES
    # ---------------
    create_table(:system_resources, ignore_index_errors: true) do
      primary_key :id
      foreign_key :system_resource_type_id, :system_resource_types, type: :integer, null: false
      String :system_resource_code, null: false
      String :description, null: false
      # Jsonb :system_resource_attributes

      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:system_resource_code], name: :system_resources_unique_code, unique: true
    end

    pgt_created_at(:system_resources,
                   :created_at,
                   function_name: :system_resources_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:system_resources,
                   :updated_at,
                   function_name: :system_resources_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('system_resources', true, true, '{updated_at}'::text[]);"

    # PLANT RESOURCES
    # ---------------
    create_table(:plant_resources, ignore_index_errors: true) do
      primary_key :id
      foreign_key :plant_resource_type_id, :plant_resource_types, type: :integer, null: false
      foreign_key :system_resource_id, :system_resources, type: :integer
      String :plant_resource_code, null: false
      String :description, null: false
      # Jsonb :plant_resource_attributes

      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:plant_resource_code], name: :plant_resources_unique_code, unique: true
    end

    pgt_created_at(:plant_resources,
                   :created_at,
                   function_name: :plant_resources_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:plant_resources,
                   :updated_at,
                   function_name: :plant_resources_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('plant_resources', true, true, '{updated_at}'::text[]);"

    # PLANT/SYSTEM RESOURCES
    # ----------------------
    create_table(:plant_resources_system_resources, ignore_index_errors: true) do
      foreign_key :plant_resource_id, :plant_resources, null: false, key: [:id]
      foreign_key :system_resource_id, :system_resources, null: false, key: [:id]
      
      primary_key [:plant_resource_id, :system_resource_id], name: :plant_resources_system_resources_pk
    end

    # TREE PLANT RESOURCES
    # --------------------
    create_table(:tree_plant_resources, ignore_index_errors: true) do
      foreign_key :ancestor_plant_resource_id, :plant_resources, null: false, key: [:id]
      foreign_key :descendant_plant_resource_id, :plant_resources, null: false, key: [:id]
      Integer :path_length
      
      primary_key [:ancestor_plant_resource_id, :descendant_plant_resource_id], name: :tree_plant_resources_pk
    end
  end

  down do
    # drop_table(:tree_resources)
    #
    # drop_table(:plant_system_resources)
    #
    # # Drop logging for resources.
    # drop_trigger(:resources, :audit_trigger_row)
    # drop_trigger(:resources, :audit_trigger_stm)
    #
    # drop_trigger(:resources, :set_created_at)
    # drop_function(:resources_set_created_at)
    # drop_trigger(:resources, :set_updated_at)
    # drop_function(:resources_set_updated_at)
    # drop_table(:resources)
    #
    # # Drop logging for resource_types.
    # drop_trigger(:resource_types, :audit_trigger_row)
    # drop_trigger(:resource_types, :audit_trigger_stm)
    #
    # drop_trigger(:resource_types, :set_created_at)
    # drop_function(:resource_types_set_created_at)
    # drop_trigger(:resource_types, :set_updated_at)
    # drop_function(:resource_types_set_updated_at)
    # drop_table(:resource_types)

    drop_table(:tree_plant_resources)

    drop_table(:plant_resources_system_resources)

    # Drop logging for plant_resources.
    drop_trigger(:plant_resources, :audit_trigger_row)
    drop_trigger(:plant_resources, :audit_trigger_stm)

    drop_trigger(:plant_resources, :set_created_at)
    drop_function(:plant_resources_set_created_at)
    drop_trigger(:plant_resources, :set_updated_at)
    drop_function(:plant_resources_set_updated_at)
    drop_table(:plant_resources)

    # Drop logging for system_resources.
    drop_trigger(:system_resources, :audit_trigger_row)
    drop_trigger(:system_resources, :audit_trigger_stm)

    drop_trigger(:system_resources, :set_created_at)
    drop_function(:system_resources_set_created_at)
    drop_trigger(:system_resources, :set_updated_at)
    drop_function(:system_resources_set_updated_at)
    drop_table(:system_resources)

    # Drop logging for plant_resource_types.
    drop_trigger(:plant_resource_types, :audit_trigger_row)
    drop_trigger(:plant_resource_types, :audit_trigger_stm)

    drop_trigger(:plant_resource_types, :set_created_at)
    drop_function(:plant_resource_types_set_created_at)
    drop_trigger(:plant_resource_types, :set_updated_at)
    drop_function(:plant_resource_types_set_updated_at)
    drop_table(:plant_resource_types)

    # Drop logging for system_resource_types.
    drop_trigger(:system_resource_types, :audit_trigger_row)
    drop_trigger(:system_resource_types, :audit_trigger_stm)

    drop_trigger(:system_resource_types, :set_created_at)
    drop_function(:system_resource_types_set_created_at)
    drop_trigger(:system_resource_types, :set_updated_at)
    drop_function(:system_resource_types_set_updated_at)
    drop_table(:system_resource_types)
  end
end
