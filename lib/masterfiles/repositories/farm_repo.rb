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
      # hash = find_hash(:farms, id)
      hash = DB['SELECT farms.* , farm_groups.farm_group_code, fn_party_role_name(farms.owner_party_role_id) AS owner_party_role,
                production_regions.production_region_code AS pdn_region_production_region_code
                FROM farms
                LEFT JOIN farm_groups ON farm_groups.id = farms.farm_group_id
                JOIN production_regions ON production_regions.id = farms.pdn_region_id
                WHERE farms.id = ?', id].first
      return nil if hash.nil?

      hash[:puc_id] = farm_primary_puc_id(id)
      Farm.new(hash)
    end

    def find_puc(id)
      hash = find_hash(:pucs, id)
      return nil if hash.nil?

      Puc.new(hash)
    end

    def find_orchard(id)
      # hash = find_hash(:orchards, id)
      hash = DB["SELECT orchards.*, farms.farm_code as farm, pucs.puc_code, string_agg(cultivars.cultivar_name, ', ') AS cultivar_names
                FROM orchards
                JOIN farms ON farms.id = orchards.farm_id
                JOIN pucs ON pucs.id = orchards.puc_id
                JOIN cultivars ON cultivars.id = ANY (orchards.cultivar_ids)
                WHERE orchards.id = ?
                GROUP BY orchards.id, farms.id, pucs.id", id].first
      return nil if hash.nil?

      Orchard.new(hash)
    end

    def create_farm(attrs)
      params = attrs.to_h
      farms_pucs_ids = Array(params.to_h.delete(:puc_id))
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

    def selected_farm_pucs(farm_id)
      DB[:pucs].join(:farms_pucs, puc_id: :id).where(farm_id: farm_id).select_map([:puc_code, :puc_id]).sort
    end

    def farm_primary_puc_id(farm_id)
      DB[:pucs].join(:farms_pucs, puc_id: :id).where(farm_id: farm_id).select_map(:puc_id).first
    end

    def select_unallocated_pucs
      query = <<~SQL
        SELECT puc_code,id
        FROM pucs
        WHERE active AND id NOT IN (SELECT distinct puc_id from farms_pucs)
      SQL
      DB[query].select_map([:puc_code, :id]).sort
    end

    def find_cultivar_names(id)
      query = <<~SQL
        SELECT cultivars.cultivar_name
        FROM orchards
        JOIN cultivars ON cultivars.id = ANY (orchards.cultivar_ids)
        WHERE orchards.id = #{id}
      SQL
      DB[query].select_map(:cultivar_name).sort
    end

    def find_farm_group_farm_codes(id)
      DB[:farms].join(:farm_groups, id: :farm_group_id).where(farm_group_id: id).select_map(:farm_code).sort
    end

  end
end
