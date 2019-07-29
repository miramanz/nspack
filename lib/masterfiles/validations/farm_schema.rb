# frozen_string_literal: true

module MasterfilesApp
  FarmSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:owner_party_role_id, :integer).filled(:int?)
    required(:pdn_region_id, :integer).filled(:int?)
    optional(:farm_group_id, :integer).maybe(:int?)
    required(:farm_code, Types::StrippedString).filled(:str?)
    required(:description, Types::StrippedString).maybe(:str?)
    required(:puc_id, :integer).filled(:int?)
  end
end
