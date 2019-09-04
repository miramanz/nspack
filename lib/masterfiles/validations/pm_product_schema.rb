# frozen_string_literal: true

module MasterfilesApp
  PmProductSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:pm_subtype_id, :integer).filled(:int?)
    required(:erp_code, Types::StrippedString).filled(:str?)
    required(:product_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).maybe(:str?)
  end
end
