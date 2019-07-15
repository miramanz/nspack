# frozen_string_literal: true

module MasterfilesApp
  OrchardSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:farm_id, :integer).filled(:int?)
    required(:puc_id, :integer).maybe(:int?)
    required(:orchard_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).maybe(:str?)
    required(:cultivars, :array).maybe(:array?) { each(:int?) }
  end
end
