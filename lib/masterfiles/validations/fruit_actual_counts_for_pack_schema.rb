# frozen_string_literal: true

module MasterfilesApp
  FruitActualCountsForPackSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:std_fruit_size_count_id, :integer).filled(:int?)
    required(:basic_pack_code_id, :integer).filled(:int?)
    required(:actual_count_for_pack, :integer).filled(:int?)
    required(:standard_pack_code_ids, Types::IntArray).filled { each(:int?) }
    required(:size_reference_ids, Types::IntArray).filled { each(:int?) }
  end
end
