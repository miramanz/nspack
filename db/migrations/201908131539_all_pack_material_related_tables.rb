require 'sequel_postgresql_triggers'
Sequel.migration do
  up do
    extension :pg_triggers
    create_table(:pm_types, ignore_index_errors: true) do
      primary_key :id
      String :pm_type_code, size: 255, null: false
      String :description, null: false
      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:pm_type_code], name: :pm_types_unique_code, unique: true
    end

    pgt_created_at(:pm_types,
                   :created_at,
                   function_name: :pm_types_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:pm_types,
                   :updated_at,
                   function_name: :pm_types_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('pm_types', true, true, '{updated_at}'::text[]);"

    create_table(:pm_subtypes, ignore_index_errors: true) do
      primary_key :id
      foreign_key :pm_type_id, :pm_types, type: :integer, null: false
      String :subtype_code, size: 255, null: false
      String :description
      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:subtype_code], name: :pm_subtypes_unique_code, unique: true
    end

    pgt_created_at(:pm_subtypes,
                   :created_at,
                   function_name: :pm_subtypes_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:pm_subtypes,
                   :updated_at,
                   function_name: :pm_subtypes_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('pm_subtypes', true, true, '{updated_at}'::text[]);"

    create_table(:pm_products, ignore_index_errors: true) do
      primary_key :id
      foreign_key :pm_subtype_id, :pm_subtypes, type: :integer, null: false
      String :erp_code, size: 255, null: false
      String :product_code, size: 255, null: false
      String :description
      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:product_code], name: :pm_products_idx, unique: true
    end

    pgt_created_at(:pm_products,
                   :created_at,
                   function_name: :pm_products_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:pm_products,
                   :updated_at,
                   function_name: :pm_products_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('pm_products', true, true, '{updated_at}'::text[]);"

    create_table(:pm_boms, ignore_index_errors: true) do
      primary_key :id
      String :bom_code, size: 255, null: false
      String :erp_bom_code
      String :description
      TrueClass :active, default: true
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:bom_code], name: :pm_boms_unique_code, unique: true
    end

    pgt_created_at(:pm_boms,
                   :created_at,
                   function_name: :pm_boms_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:pm_boms,
                   :updated_at,
                   function_name: :pm_boms_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('pm_boms', true, true, '{updated_at}'::text[]);"

    create_table(:pm_boms_products, ignore_index_errors: true) do
      primary_key :id
      foreign_key :pm_product_id, :pm_products, type: :integer, null: false
      foreign_key :pm_bom_id, :pm_boms, type: :integer, null: false
      foreign_key :uom_id, :uoms, type: :integer, null: false
      Decimal :quantity, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index [:pm_product_id, :pm_bom_id, :uom_id], name: :pm_boms_products_idx, unique: true
    end

    pgt_created_at(:pm_boms_products,
                   :created_at,
                   function_name: :pm_boms_products_set_created_at,
                   trigger_name: :set_created_at)

    pgt_updated_at(:pm_boms_products,
                   :updated_at,
                   function_name: :pm_boms_products_set_updated_at,
                   trigger_name: :set_updated_at)

    # Log changes to this table. Exclude changes to the updated_at column.
    run "SELECT audit.audit_table('pm_boms_products', true, true, '{updated_at}'::text[]);"


  end

  down do
    # Drop logging for this table.
    drop_trigger(:pm_boms_products, :audit_trigger_row)
    drop_trigger(:pm_boms_products, :audit_trigger_stm)

    drop_trigger(:pm_boms_products, :set_created_at)
    drop_function(:pm_boms_products_set_created_at)
    drop_trigger(:pm_boms_products, :set_updated_at)
    drop_function(:pm_boms_products_set_updated_at)
    drop_table(:pm_boms_products)

    drop_trigger(:pm_boms, :audit_trigger_row)
    drop_trigger(:pm_boms, :audit_trigger_stm)

    drop_trigger(:pm_boms, :set_created_at)
    drop_function(:pm_boms_set_created_at)
    drop_trigger(:pm_boms, :set_updated_at)
    drop_function(:pm_boms_set_updated_at)
    drop_table(:pm_boms)

    drop_trigger(:pm_products, :audit_trigger_row)
    drop_trigger(:pm_products, :audit_trigger_stm)

    drop_trigger(:pm_products, :set_created_at)
    drop_function(:pm_products_set_created_at)
    drop_trigger(:pm_products, :set_updated_at)
    drop_function(:pm_products_set_updated_at)
    drop_table(:pm_products)

    drop_trigger(:pm_subtypes, :audit_trigger_row)
    drop_trigger(:pm_subtypes, :audit_trigger_stm)

    drop_trigger(:pm_subtypes, :set_created_at)
    drop_function(:pm_subtypes_set_created_at)
    drop_trigger(:pm_subtypes, :set_updated_at)
    drop_function(:pm_subtypes_set_updated_at)
    drop_table(:pm_subtypes)

    drop_trigger(:pm_types, :audit_trigger_row)
    drop_trigger(:pm_types, :audit_trigger_stm)

    drop_trigger(:pm_types, :set_created_at)
    drop_function(:pm_types_set_created_at)
    drop_trigger(:pm_types, :set_updated_at)
    drop_function(:pm_types_set_updated_at)
    drop_table(:pm_types)
  end
end
