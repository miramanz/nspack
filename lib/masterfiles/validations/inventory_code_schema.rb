# frozen_string_literal: true

module MasterfilesApp
  InventoryCodeSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:inventory_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).maybe(:str?)
  end
end
