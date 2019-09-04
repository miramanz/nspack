# frozen_string_literal: true

module MasterfilesApp
  PmTypeSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:pm_type_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).filled(:str?)
  end
end
