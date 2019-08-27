# frozen_string_literal: true

module MasterfilesApp
  CustomerVarietySchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:variety_as_customer_variety_id, :integer).filled(:int?)
    required(:packed_tm_group_id, :integer).filled(:int?)
  end
end
