# frozen_string_literal: true

module MasterfilesApp
  CartonsPerPalletSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:description, Types::StrippedString).maybe(:str?)
    required(:pallet_format_id, :integer).filled(:int?)
    required(:basic_pack_id, :integer).filled(:int?)
    required(:cartons_per_pallet, :integer).filled(:int?)
    required(:layers_per_pallet, :integer).filled(:int?)
  end
end
