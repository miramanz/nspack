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

    def find_farm(id)
      hash = find_hash(:farms, id)
      return nil if hash.nil?

      hash[:farms_pucs_ids] = farms_pucs_ids(id)
      Farm.new(hash)
    end

    def find_puc(id)
      hash = find_hash(:pucs, id)
      return nil if hash.nil?

      Puc.new(hash)
    end

    def create_farm(attrs)
      params = attrs.to_h
      farms_pucs_ids = params.delete(:farms_pucs_ids)
      return { error: { roles: ['You did not choose a puc'] } } if farms_pucs_ids.empty?

      farm_id = DB[:farms].insert(params)
      farms_pucs_ids.each do |puc_id|
        DB[:farms_pucs].insert(farm_id: farm_id,
                               puc_id: puc_id)
      end
      { id: farm_id }
    end

    def associate_farms_pucs(id, farms_pucs_ids)
      return { error: 'Choose at least one puc' } if farms_pucs_ids.empty?

      existing_farms_pucs_ids = DB[:farms_pucs].where(farm_id: id).select_map(:puc_id)
      removed_farms_pucs_ids = existing_farms_pucs_ids - farms_pucs_ids
      new_farms_pucs_ids = farms_pucs_ids - existing_farms_pucs_ids
      DB[:farms_pucs].where(farm_id: id).where(puc_id: removed_farms_pucs_ids).delete
      new_farms_pucs_ids.each do |puc_id|
        DB[:farms_pucs].insert(farm_id: id,
                               puc_id: puc_id)
      end
    end

    def delete_farm(id)
      DB[:farms_pucs].where(farm_id: id).delete
      DB[:farms].where(id: id).delete
      { success: true }
    end

    def delete_farms_pucs(puc_id)
      DB[:farms_pucs].where(puc_id: puc_id).delete
    end

    def find_puc_farm_codes(id)
      DB[:farms].join(:farms_pucs, farm_id: :id).where(puc_id: id).select_map(:farm_code).sort
    end

    def find_farm_puc_codes(id)
      DB[:pucs].join(:farms_pucs, puc_id: :id).where(farm_id: id).select_map(:puc_code).sort
    end

    def find_farm_orchard_codes(id)
      DB[:orchards].join(:farms, id: :farm_id).where(farm_id: id).select_map(:orchard_code).sort
    end

    def farms_pucs_ids(farm_id)
      DB[:farms_pucs].where(farm_id: farm_id).select_map(:puc_id).sort
    end

    def selected_farm_pucs(farm_id)
      DB[:pucs].join(:farms_pucs, puc_id: :id).where(farm_id: farm_id).select_map([:puc_code, :puc_id]).sort
    end

    def find_cultivar_names(id)
      DB[:cultivars].where(id: id).select_map(:cultivar_name).sort
    end

  end
end
