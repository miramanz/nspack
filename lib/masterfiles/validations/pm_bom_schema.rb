# frozen_string_literal: true

module MasterfilesApp
  PmBomSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:bom_code, Types::StrippedString).filled(:str?)
    required(:erp_bom_code, Types::StrippedString).maybe(:str?)
    required(:description, Types::StrippedString).maybe(:str?)
  end
end
