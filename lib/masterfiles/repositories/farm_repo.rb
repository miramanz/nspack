# frozen_string_literal: true

module MasterfilesApp
  class FarmRepo < BaseRepo
    build_for_select :production_regions,
                     label: :production_region_code,
                     value: :id,
                     order_by: :production_region_code
    build_inactive_select :production_regions,
                          label: :production_region_code,
                          value: :id,
                          order_by: :production_region_code

    crud_calls_for :production_regions, name: :production_region, wrapper: ProductionRegion
  end
end
