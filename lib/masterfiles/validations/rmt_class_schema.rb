# frozen_string_literal: true

module MasterfilesApp
  RmtClassSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:rmt_class_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).filled(:str?)
  end
end
