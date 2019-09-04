# frozen_string_literal: true

module MasterfilesApp
  PmSubtypeSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:pm_type_id, :integer).filled(:int?)
    required(:subtype_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).maybe(:str?)
  end
end
