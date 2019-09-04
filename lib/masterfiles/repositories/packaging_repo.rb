# frozen_string_literal: true

module MasterfilesApp
  class PackagingRepo < BaseRepo
    build_for_select :pallet_bases,
                     label: :pallet_base_code,
                     value: :id,
                     order_by: :pallet_base_code
    build_inactive_select :pallet_bases,
                          label: :pallet_base_code,
                          value: :id,
                          order_by: :pallet_base_code

    build_for_select :pallet_stack_types,
                     label: :stack_type_code,
                     value: :id,
                     order_by: :stack_type_code
    build_inactive_select :pallet_stack_types,
                          label: :stack_type_code,
                          value: :id,
                          order_by: :stack_type_code

    build_for_select :pallet_formats,
                     label: :description,
                     value: :id,
                     order_by: :description
    build_inactive_select :pallet_formats,
                          label: :description,
                          value: :id,
                          order_by: :description

    build_for_select :cartons_per_pallet,
                     label: :description,
                     value: :id,
                     order_by: :description
    build_inactive_select :cartons_per_pallet,
                          label: :description,
                          value: :id,
                          order_by: :description

    crud_calls_for :pallet_bases, name: :pallet_base, wrapper: PalletBase
    crud_calls_for :pallet_stack_types, name: :pallet_stack_type, wrapper: PalletStackType
    crud_calls_for :pallet_formats, name: :pallet_format, wrapper: PalletFormat
    crud_calls_for :cartons_per_pallet, name: :cartons_per_pallet, wrapper: CartonsPerPallet

    def find_pallet_base_pallet_formats(id)
      DB[:pallet_formats]
        .join(:pallet_bases, id: :pallet_base_id)
        .where(pallet_base_id: id)
        .order(Sequel[:pallet_formats][:description])
        .select_map(Sequel[:pallet_formats][:description])
    end

    def find_pallet_stack_type_pallet_formats(id)
      DB[:pallet_formats]
        .join(:pallet_stack_types, id: :pallet_stack_type_id)
        .where(pallet_stack_type_id: id)
        .order(Sequel[:pallet_formats][:description])
        .select_map(Sequel[:pallet_formats][:description])
    end

    def find_pallet_format(id)
      hash = find_with_association(:pallet_formats,
                                   id,
                                   parent_tables: [{ parent_table: :pallet_bases,
                                                     columns: [:pallet_base_code],
                                                     foreign_key: :pallet_base_id,
                                                     flatten_columns: { pallet_base_code: :pallet_base_code } },
                                                   { parent_table: :pallet_stack_types,
                                                     columns: [:stack_type_code],
                                                     flatten_columns: { stack_type_code: :stack_type_code } }])
      return nil if hash.nil?

      PalletFormat.new(hash)
    end

    def find_cartons_per_pallet(id)
      hash = find_with_association(:cartons_per_pallet,
                                   id,
                                   parent_tables: [{ parent_table: :basic_pack_codes,
                                                     columns: [:basic_pack_code],
                                                     foreign_key: :basic_pack_id,
                                                     flatten_columns: { basic_pack_code: :basic_pack_code } },
                                                   { parent_table: :pallet_formats,
                                                     columns: [:description],
                                                     flatten_columns: { description: :pallet_formats_description } }])
      return nil if hash.nil?

      CartonsPerPallet.new(hash)
    end
  end
end
