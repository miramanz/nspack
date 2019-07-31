# frozen_string_literal: true

# ========================================================= #
# NB. Scaffolds for test factories should be combined       #
#     - Otherwise you'll have methods for the same table in #
#       several factories.                                  #
#     - Rather create a factory for several related tables  #
# ========================================================= #

module MasterfilesApp
  module FarmsFactory # rubocop:disable Metrics/ModuleLength
    def create_party(opts = {})
      default = {
        party_type: 'O', # || 'P'
        active: true
      }
      DB[:parties].insert(default.merge(opts))
    end

    def create_party_role(opts = {})
      party_id = create_party
      role_id = create_role
      organization_id = create_organization
      person_id = create_person

      default = {
        party_id: party_id,
        role_id: role_id,
        organization_id: organization_id,
        person_id: person_id,
        active: true
      }
      DB[:party_roles].insert(default.merge(opts))
    end

    def create_role(opts = {})
      default = {
        name: Faker::Lorem.word,
        active: true
      }
      DB[:roles].insert(default.merge(opts))
    end

    def create_organization(opts = {})
      party_id = create_party(party_type: 'O')
      default = {
        party_id: party_id,
        parent_id: nil,
        short_description: Faker::Company.unique.name.to_s,
        medium_description: Faker::Company.unique.name.to_s,
        long_description: Faker::Company.unique.name.to_s,
        vat_number: Faker::Number.number(10),
        active: true
      }
      DB[:organizations].insert(default.merge(opts))
    end

    def create_person(opts = {})
      party_id = create_party(party_type: 'P')
      default = {
        party_id: party_id,
        surname: Faker::Company.name.to_s,
        first_name: Faker::Company.name.to_s,
        title: Faker::Company.name.to_s,
        vat_number: Faker::Number.number(10),
        active: true
      }
      DB[:people].insert(default.merge(opts))
    end

    def create_production_region(opts = {})
      default = {
        production_region_code: Faker::Lorem.word,
        description: Faker::Lorem.word,
        active: true,
        created_at: '2010-01-01 12:00',
        updated_at: '2010-01-01 12:00'
      }
      DB[:production_regions].insert(default.merge(opts))
    end

    def create_farm_group(opts = {})
      party_role_id = create_party_role

      default = {
        owner_party_role_id: party_role_id,
        farm_group_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        active: true,
        created_at: '2010-01-01 12:00',
        updated_at: '2010-01-01 12:00'
      }
      DB[:farm_groups].insert(default.merge(opts))
    end

    def create_farm(opts = {})
      party_role_id = create_party_role
      production_region_id = create_production_region
      farm_group_id = create_farm_group

      default = {
        owner_party_role_id: party_role_id,
        pdn_region_id: production_region_id,
        farm_group_id: farm_group_id,
        farm_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        active: true,
        puc_id: 1,
        created_at: '2010-01-01 12:00',
        updated_at: '2010-01-01 12:00'
      }
      DB[:farms].insert(default.merge(opts).delete(:puc_id))
    end

    def create_puc(opts = {})
      default = {
        puc_code: Faker::Lorem.unique.word,
        gap_code: Faker::Lorem.word,
        active: true,
        created_at: '2010-01-01 12:00',
        updated_at: '2010-01-01 12:00'
      }
      DB[:pucs].insert(default.merge(opts))
    end

    def create_orchard(opts = {})
      farm_id = create_farm
      puc_id = create_puc

      default = {
        farm_id: farm_id,
        orchard_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        cultivar_ids: '{1, 2, 3}',
        active: true,
        created_at: '2010-01-01 12:00',
        updated_at: '2010-01-01 12:00',
        puc_id: puc_id
      }
      DB[:orchards].insert(default.merge(opts))
    end

    def create_farms_pucs(opts = {})
      default = {
        farm_id: create_farm,
        puc_id: create_puc
      }
      DB[:farms_pucs].insert(default.merge(opts))
    end
  end
end
