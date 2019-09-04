# frozen_string_literal: true

module Masterfiles
  module Packaging
    module PmProduct
      class New
        def self.call(form_values: nil, form_errors: nil, remote: true) # rubocop:disable Metrics/AbcSize
          ui_rule = UiRules::Compiler.new(:pm_product, :new, form_values: form_values)
          rules   = ui_rule.compile

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object ui_rule.form_object
            page.form_values form_values
            page.form_errors form_errors
            page.form do |form|
              form.caption 'New Pm Product'
              form.action '/masterfiles/packaging/pm_products'
              form.remote! if remote
              form.add_field :pm_subtype_id
              form.add_field :erp_code
              form.add_field :product_code
              form.add_field :description
            end
          end

          layout
        end
      end
    end
  end
end
