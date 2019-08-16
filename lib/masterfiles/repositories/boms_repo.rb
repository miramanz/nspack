# frozen_string_literal: true

module MasterfilesApp
  class BomsRepo < BaseRepo
    build_for_select :pm_types,
                     label: :pm_type_code,
                     value: :id,
                     order_by: :pm_type_code
    build_inactive_select :pm_types,
                          label: :pm_type_code,
                          value: :id,
                          order_by: :pm_type_code

    build_for_select :pm_subtypes,
                     label: :subtype_code,
                     value: :id,
                     order_by: :subtype_code
    build_inactive_select :pm_subtypes,
                          label: :subtype_code,
                          value: :id,
                          order_by: :subtype_code

    build_for_select :pm_products,
                     label: :product_code,
                     value: :id,
                     order_by: :product_code
    build_inactive_select :pm_products,
                          label: :product_code,
                          value: :id,
                          order_by: :product_code

    build_for_select :units_of_measure,
                     label: :unit_of_measure,
                     value: :id,
                     order_by: :unit_of_measure
    build_inactive_select :units_of_measure,
                          label: :unit_of_measure,
                          value: :id,
                          order_by: :unit_of_measure

    build_for_select :pm_boms,
                     label: :bom_code,
                     value: :id,
                     order_by: :bom_code
    build_inactive_select :pm_boms,
                          label: :bom_code,
                          value: :id,
                          order_by: :bom_code

    build_for_select :pm_boms_products,
                     label: :id,
                     value: :id,
                     no_active_check: true,
                     order_by: :id

    crud_calls_for :pm_types, name: :pm_type, wrapper: PmType
    crud_calls_for :pm_subtypes, name: :pm_subtype, wrapper: PmSubtype
    crud_calls_for :pm_products, name: :pm_product, wrapper: PmProduct
    crud_calls_for :units_of_measure, name: :units_of_measure, wrapper: UnitsOfMeasure
    crud_calls_for :pm_boms, name: :pm_bom, wrapper: PmBom
    crud_calls_for :pm_boms_products, name: :pm_boms_product, wrapper: PmBomsProduct

    def find_pm_type_subtypes(id)
      DB[:pm_subtypes]
        .join(:pm_types, id: :pm_type_id)
        .where(pm_type_id: id)
        .order(:subtype_code)
        .select_map(:subtype_code)
    end

    def find_pm_subtype_products(id)
      DB[:pm_products]
        .join(:pm_subtypes, id: :pm_subtype_id)
        .where(pm_subtype_id: id)
        .order(:product_code)
        .select_map(:product_code)
    end

    def find_pm_subtype(id)
      hash = find_with_association(:pm_subtypes,
                                   id,
                                   parent_tables: [{ parent_table: :pm_types,
                                                     columns: [:pm_type_code],
                                                     flatten_columns: { pm_type_code: :pm_type_code } }])
      return nil if hash.nil?

      PmSubtype.new(hash)
    end

    def find_pm_product(id)
      hash = find_with_association(:pm_products,
                                   id,
                                   parent_tables: [{ parent_table: :pm_subtypes,
                                                     columns: [:subtype_code],
                                                     flatten_columns: { subtype_code: :subtype_code } }])
      return nil if hash.nil?

      PmProduct.new(hash)
    end

    def find_pm_boms_product(id)
      hash = find_with_association(:pm_boms_products,
                                   id,
                                   parent_tables: [{ parent_table: :pm_products,
                                                     columns: [:product_code],
                                                     flatten_columns: { product_code: :product_code } },
                                                   { parent_table: :pm_boms,
                                                     columns: [:bom_code],
                                                     flatten_columns: { bom_code: :bom_code } },
                                                   { parent_table: :units_of_measure,
                                                     columns: [:unit_of_measure],
                                                     foreign_key: :unit_of_measure_id,
                                                     flatten_columns: { unit_of_measure: :unit_of_measure } }])
      return nil if hash.nil?

      PmBomsProduct.new(hash)
    end
  end
end
