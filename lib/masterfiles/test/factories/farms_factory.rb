# frozen_string_literal: true

module MasterfilesApp
  module FarmsFactory
    def create_production_region(opts = {})
      default = {
        production_region_code: Faker::Lorem.word,
        description: Faker::Lorem.word,
        active: true
      }
      DB[:production_regions].insert(default.merge(opts))
    end

    def create_puc(opts = {})
      default = {
        puc_code: Faker::Lorem.unique.word,
        gap_code: Faker::Lorem.word,
        active: true
      }
      DB[:pucs].insert(default.merge(opts))
    end

    def create_farm_group(opts = {})
      party_role_id = create_party_role('O')[:id].to_i

      default = {
        owner_party_role_id: party_role_id,
        farm_group_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        active: true
      }
      DB[:farm_groups].insert(default.merge(opts))
    end

    def create_farm(opts = {})
      party_role_id = create_party_role('O')[:id].to_i
      production_region_id = create_production_region
      farm_group_id = create_farm_group
      puc_id = create_puc

      default = {
        owner_party_role_id: party_role_id,
        pdn_region_id: production_region_id,
        farm_group_id: farm_group_id,
        farm_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        active: true,
        puc_id: puc_id
      }
      default.delete(:puc_id)
      id = DB[:farms].insert(default.merge(opts))
      {
        id: id
      }
    end

    def create_orchard(opts = {})
      farm_id = create_farm[:id]
      puc_id = create_puc
      cultivar_id = create_cultivar

      default = {
        farm_id: farm_id,
        orchard_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        cultivar_ids: "{#{cultivar_id}}",
        active: true,
        puc_id: puc_id
      }
      DB[:orchards].insert(default.merge(opts))
    end
  end
end
