# frozen_string_literal: true

module Masterfiles
  module Fruit
    module Treatment
      class Edit
        def self.call(id, form_values: nil, form_errors: nil) # rubocop:disable Metrics/AbcSize
          ui_rule = UiRules::Compiler.new(:treatment, :edit, id: id, form_values: form_values)
          rules   = ui_rule.compile

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object ui_rule.form_object
            page.form_values form_values
            page.form_errors form_errors
            page.form do |form|
              form.caption 'Edit Treatment'
              form.action "/masterfiles/fruit/treatments/#{id}"
              form.remote!
              form.method :update
              form.add_field :treatment_type_id
              form.add_field :treatment_code
              form.add_field :description
            end
          end

          layout
        end
      end
    end
  end
end
