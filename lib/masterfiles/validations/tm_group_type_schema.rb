# frozen_string_literal: true

module MasterfilesApp
  TmGroupTypeSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:target_market_group_type_code, Types::StrippedString).filled(:str?)
  end
end
