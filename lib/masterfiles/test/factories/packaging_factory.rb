# frozen_string_literal: true

module MasterfilesApp
  module PackagingFactory
    def create_pallet_base(opts = {})
      default = {
        pallet_base_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        length: Faker::Number.number(4),
        width: Faker::Number.number(4),
        edi_in_pallet_base: Faker::Lorem.word,
        edi_out_pallet_base: Faker::Lorem.word,
        cartons_per_layer: Faker::Number.number(4),
        active: true
      }
      DB[:pallet_bases].insert(default.merge(opts))
    end

    def create_pallet_stack_type(opts = {})
      default = {
        stack_type_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        stack_height: Faker::Number.number(4),
        active: true
      }
      DB[:pallet_stack_types].insert(default.merge(opts))
    end

    def create_pallet_format(opts = {})
      pallet_base_id = create_pallet_base
      pallet_stack_type_id = create_pallet_stack_type

      default = {
        description: Faker::Lorem.unique.word,
        pallet_base_id: pallet_base_id,
        pallet_stack_type_id: pallet_stack_type_id
      }
      DB[:pallet_formats].insert(default.merge(opts))
    end

    def create_cartons_per_pallet(opts = {})
      pallet_format_id = create_pallet_format
      basic_pack_code_id = create_basic_pack_code

      default = {
        description: Faker::Lorem.unique.word,
        pallet_format_id: pallet_format_id,
        basic_pack_id: basic_pack_code_id,
        cartons_per_pallet: Faker::Number.number(4),
        layers_per_pallet: Faker::Number.number(4),
        active: true
      }
      DB[:cartons_per_pallet].insert(default.merge(opts))
    end
  end
end
