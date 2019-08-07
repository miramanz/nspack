# frozen_string_literal: true

module MasterfilesApp
  PalletStackTypeSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:stack_type_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).maybe(:str?)
    required(:stack_height, :integer).filled(:int?)
  end
end
