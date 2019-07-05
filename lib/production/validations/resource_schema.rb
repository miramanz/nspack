# frozen_string_literal: true

module ProductionApp
  ResourceSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:resource_type_id, :integer).filled(:int?)
    required(:system_resource_id, :integer).maybe(:int?)
    required(:resource_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).filled(:str?)
    required(:resource_attributes, :hash).maybe(:hash?)
  end
end
