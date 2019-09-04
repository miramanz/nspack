# frozen_string_literal: true

module Masterfiles
  module General
    module Uom
      class Edit
        def self.call(id, form_values: nil, form_errors: nil)
          ui_rule = UiRules::Compiler.new(:uom, :edit, id: id, form_values: form_values)
          rules   = ui_rule.compile

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object ui_rule.form_object
            page.form_values form_values
            page.form_errors form_errors
            page.form do |form|
              form.caption 'Edit UOM'
              form.action "/masterfiles/general/uoms/#{id}"
              form.remote!
              form.method :update
              form.add_field :uom_type_id
              form.add_field :uom_code
            end
          end

          layout
        end
      end
    end
  end
end
