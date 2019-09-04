# frozen_string_literal: true

module Masterfiles
  module Marketing
    module CustomerVariety
      class Show
        def self.call(id)
          ui_rule = UiRules::Compiler.new(:customer_variety, :show, id: id)
          rules   = ui_rule.compile

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object ui_rule.form_object
            page.form do |form|
              # form.caption 'Customer Variety'
              form.view_only!
              form.add_field :variety_as_customer_variety_id
              form.add_field :packed_tm_group_id
              form.add_field :active
              form.add_field :marketing_varieties
            end
          end

          layout
        end
      end
    end
  end
end
