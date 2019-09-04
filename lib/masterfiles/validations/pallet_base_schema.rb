# frozen_string_literal: true

module MasterfilesApp
  PalletBaseSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:pallet_base_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).maybe(:str?)
    required(:length, :integer).filled(:int?)
    required(:width, :integer).filled(:int?)
    required(:edi_in_pallet_base, Types::StrippedString).maybe(:str?)
    required(:edi_out_pallet_base, Types::StrippedString).maybe(:str?)
    required(:cartons_per_layer, :integer).filled(:int?)
  end
end
