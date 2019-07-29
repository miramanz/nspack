# frozen_string_literal: true

module MasterfilesApp
  RmtContainerTypeSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    optional(:active, :bool).filled(:bool?)
    required(:container_type_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).maybe(:str?)
  end
end
