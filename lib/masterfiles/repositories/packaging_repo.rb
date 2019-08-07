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

    crud_calls_for :pallet_bases, name: :pallet_base, wrapper: PalletBase
    crud_calls_for :pallet_stack_types, name: :pallet_stack_type, wrapper: PalletStackType

    def find_pallet_base_pallet_formats(id)
      DB[:pallet_formats]
        .join(:pallet_bases, id: :pallet_base_id)
        .where(pallet_base_id: id)
        .order(:pallet_base_code)
        .select_map(:pallet_base_code)
    end

    def find_pallet_stack_type_pallet_formats(id)
      DB[:pallet_formats]
        .join(:pallet_stack_types, id: :pallet_stack_type_id)
        .where(pallet_stack_type_id: id)
        .order(:stack_type_code)
        .select_map(:stack_type_code)
    end
  end
end
