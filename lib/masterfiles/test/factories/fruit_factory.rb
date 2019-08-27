# frozen_string_literal: true

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

    def create_basic_pack_code(opts = {})
      default = {
        basic_pack_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        length_mm: Faker::Number.number(4),
        width_mm: Faker::Number.number(4),
        height_mm: Faker::Number.number(4)
      }
      DB[:basic_pack_codes].insert(default.merge(opts))
    end

    def create_standard_pack_code(opts = {})
      default = {
        standard_pack_code: Faker::Lorem.unique.word
      }
      DB[:standard_pack_codes].insert(default.merge(opts))
    end
  end
end
