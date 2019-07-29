# frozen_string_literal: true

# ========================================================= #
# NB. Scaffolds for test factories should be combined       #
#     - Otherwise you'll have methods for the same table in #
#       several factories.                                  #
#     - Rather create a factory for several related tables  #
# ========================================================= #

module MasterfilesApp
  module FarmsFactory
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
        active: true,
        created_at: '2010-01-01 12:00',
        updated_at: '2010-01-01 12:00'
      }
      DB[:party_roles].insert(default.merge(opts))
    end

    def create_party(opts = {})
      default = {
        party_type: Faker::Lorem.word,
        active: true,
        created_at: '2010-01-01 12:00',
        updated_at: '2010-01-01 12:00'
      }
      DB[:parties].insert(default.merge(opts))
    end

    def create_role(opts = {})
      default = {
        name: Faker::Lorem.word,
        active: true,
        created_at: '2010-01-01 12:00',
        updated_at: '2010-01-01 12:00'
      }
      DB[:roles].insert(default.merge(opts))
    end

    def create_organization(opts = {})
      default = {
        party_id: Faker::Number.number,
        parent_id: Faker::Number.number,
        short_description: Faker::Lorem.word,
        medium_description: Faker::Lorem.word,
        long_description: Faker::Lorem.word,
        vat_number: Faker::Lorem.word,
        variants: ['A', 'B', 'C'],
        active: true,
        created_at: '2010-01-01 12:00',
        updated_at: '2010-01-01 12:00'
      }
      DB[:organizations].insert(default.merge(opts))
    end

    def create_person(opts = {})
      default = {
        party_id: Faker::Number.number,
        surname: Faker::Lorem.word,
        first_name: Faker::Lorem.word,
        title: Faker::Lorem.word,
        vat_number: Faker::Lorem.word,
        active: true,
        created_at: '2010-01-01 12:00',
        updated_at: '2010-01-01 12:00'
      }
      DB[:people].insert(default.merge(opts))
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
          created_at: '2010-01-01 12:00',
          updated_at: '2010-01-01 12:00'
      }
      DB[:farms].insert(default.merge(opts))
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
          cultivar_ids: [1, 2, 3],
          active: true,
          created_at: '2010-01-01 12:00',
          updated_at: '2010-01-01 12:00',
          puc_id: puc_id
      }
      DB[:orchards].insert(default.merge(opts))
    end

  end
end
