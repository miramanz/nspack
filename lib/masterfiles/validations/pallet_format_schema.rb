# frozen_string_literal: true

module MasterfilesApp
  PalletFormatSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:description, Types::StrippedString).filled(:str?)
    required(:pallet_base_id, :integer).filled(:int?)
    required(:pallet_stack_type_id, :integer).filled(:int?)
  end
end
