# frozen_string_literal: true

# ========================================================= #
# NB. Scaffolds for test factories should be combined       #
#     - Otherwise you'll have methods for the same table in #
#       several factories.                                  #
#     - Rather create a factory for several related tables  #
# ========================================================= #

module MasterfilesApp
  module FruitFactory
    def create_grade(opts = {})
      default = {
        grade_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        active: true
      }
      DB[:grades].insert(default.merge(opts))
    end

    def create_treatment_type(opts = {})
      default = {
        treatment_type_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        active: true
      }
      DB[:treatment_types].insert(default.merge(opts))
    end

    def create_treatment(opts = {})
      treatment_type_id = create_treatment_type

      default = {
        treatment_type_id: treatment_type_id,
        treatment_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        active: true
      }
      DB[:treatments].insert(default.merge(opts))
    end

    def create_inventory_code(opts = {})
      default = {
        inventory_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        active: true
      }
      DB[:inventory_codes].insert(default.merge(opts))
    end
  end
end
