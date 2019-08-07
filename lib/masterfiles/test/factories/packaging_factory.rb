# frozen_string_literal: true

# ========================================================= #
# NB. Scaffolds for test factories should be combined       #
#     - Otherwise you'll have methods for the same table in #
#       several factories.                                  #
#     - Rather create a factory for several related tables  #
# ========================================================= #

module MasterfilesApp
  module PackagingFactory
    def create_pallet_base(opts = {})
      default = {
        pallet_base_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        length: Faker::Number.number,
        width: Faker::Number.number,
        edi_in_pallet_base: Faker::Lorem.word,
        edi_out_pallet_base: Faker::Lorem.word,
        cartons_per_layer: Faker::Number.number,
        active: true
      }
      DB[:pallet_bases].insert(default.merge(opts))
    end

    def create_pallet_stack_type(opts = {})
      default = {
        stack_type_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        stack_height: Faker::Number.number,
        active: true
      }
      DB[:pallet_stack_types].insert(default.merge(opts))
    end
  end
end
