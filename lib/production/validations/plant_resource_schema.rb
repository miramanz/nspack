# frozen_string_literal: true

module ProductionApp
  PlantResourceSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    optional(:plant_resource_type_id, :integer).filled(:int?)
    # optional(:system_resource_id, :integer).maybe(:int?)
    required(:plant_resource_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).filled(:str?)
    # optional(:plant_resource_attributes, :hash).maybe(:hash?)
  end
end
