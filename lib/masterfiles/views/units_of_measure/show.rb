# frozen_string_literal: true

module Masterfiles
  module Packaging
    module UnitsOfMeasure
      class Show
        def self.call(id)
          ui_rule = UiRules::Compiler.new(:units_of_measure, :show, id: id)
          rules   = ui_rule.compile

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object ui_rule.form_object
            page.form do |form|
              # form.caption 'Units Of Measure'
              form.view_only!
              form.add_field :unit_of_measure
              form.add_field :description
              form.add_field :active
            end
          end

          layout
        end
      end
    end
  end
end
