# frozen_string_literal: true

module ProductionApp
  ResourceTypeSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:resource_type_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).filled(:str?)
    required(:system_resource, :bool).filled(:bool?)
    optional(:attribute_rules, :hash).maybe(:hash?)
    optional(:behaviour_rules, :hash).maybe(:hash?)
  end
end
