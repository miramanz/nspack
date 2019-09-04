# frozen_string_literal: true

module MasterfilesApp
  PmBomsProductSchema = Dry::Validation.Params do
    configure { config.type_specs = true }

    optional(:id, :integer).filled(:int?)
    required(:pm_product_id, :integer).filled(:int?)
    required(:pm_bom_id, :integer).filled(:int?)
    required(:uom_id, :integer).filled(:int?)
    required(:quantity, :decimal).filled(:decimal?)
  end
end
