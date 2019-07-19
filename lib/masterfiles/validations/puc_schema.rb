# frozen_string_literal: true

module MasterfilesApp
  PucSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:puc_code, Types::StrippedString).filled(:str?)
    required(:gap_code, Types::StrippedString).maybe(:str?)
    required(:active, :bool).filled(:bool?)
  end
end
