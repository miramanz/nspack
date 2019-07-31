# frozen_string_literal: true

module MasterfilesApp
  FarmGroupSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:owner_party_role_id, :integer).filled(:int?)
    required(:farm_group_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).maybe(:str?)
  end
end
