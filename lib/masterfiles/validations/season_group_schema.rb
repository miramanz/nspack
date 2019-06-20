# frozen_string_literal: true

module MasterfilesApp
  SeasonGroupSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:season_group_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).maybe(:str?)
    required(:season_group_year, :integer).maybe(:int?)
  end
end
