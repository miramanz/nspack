# frozen_string_literal: true

module Masterfiles
  module Packaging
    module UnitsOfMeasure
      class New
        def self.call(form_values: nil, form_errors: nil, remote: true)
          ui_rule = UiRules::Compiler.new(:units_of_measure, :new, form_values: form_values)
          rules   = ui_rule.compile

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object ui_rule.form_object
            page.form_values form_values
            page.form_errors form_errors
            page.form do |form|
              form.caption 'New Units Of Measure'
              form.action '/masterfiles/packaging/units_of_measure'
              form.remote! if remote
              form.add_field :unit_of_measure
              form.add_field :description
            end
          end

          layout
        end
      end
    end
  end
end
