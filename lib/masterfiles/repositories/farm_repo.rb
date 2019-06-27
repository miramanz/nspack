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

    build_for_select :farm_groups,
                     label: :farm_group_code,
                     value: :id,
                     order_by: :farm_group_code
    build_inactive_select :farm_groups,
                          label: :farm_group_code,
                          value: :id,
                          order_by: :farm_group_code

    build_for_select :farms,
                     label: :farm_code,
                     value: :id,
                     order_by: :farm_code
    build_inactive_select :farms,
                          label: :farm_code,
                          value: :id,
                          order_by: :farm_code

    build_for_select :orchards,
                     label: :orchard_code,
                     value: :id,
                     order_by: :orchard_code
    build_inactive_select :orchards,
                          label: :orchard_code,
                          value: :id,
                          order_by: :orchard_code

    build_for_select :pucs,
                     label: :puc_code,
                     value: :id,
                     order_by: :puc_code
    build_inactive_select :pucs,
                          label: :puc_code,
                          value: :id,
                          order_by: :puc_code

    crud_calls_for :production_regions, name: :production_region, wrapper: ProductionRegion
    crud_calls_for :farm_groups, name: :farm_group, wrapper: FarmGroup
    crud_calls_for :farms, name: :farm, wrapper: Farm
    crud_calls_for :orchards, name: :orchard, wrapper: Orchard
    crud_calls_for :pucs, name: :puc, wrapper: Puc

    def find_puc(id)
      hash = find_hash(:pucs, id)
      return nil if hash.nil?

      Puc.new(hash)
    end

    def create_farms_pucs(id, puc_id)
      DB[:farms_pucs].insert(farm_id: id,
                             puc_id: puc_id)
    end
  end
end
