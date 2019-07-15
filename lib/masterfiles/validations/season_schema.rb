# frozen_string_literal: true

module MasterfilesApp
  SeasonSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:season_group_id, :integer).filled(:int?)
    required(:commodity_id, :integer).filled(:int?)
    required(:season_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).maybe(:str?)
    required(:season_year, :integer).maybe(:int?)
    required(:start_date, :date).maybe(:date?)
    required(:end_date, :date).maybe(:date?)
  end
end
