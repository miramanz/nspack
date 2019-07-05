# frozen_string_literal: true

module Production
  module Resources
    module Resource
      class Show
        def self.call(id)
          ui_rule = UiRules::Compiler.new(:resource, :show, id: id)
          rules   = ui_rule.compile

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object ui_rule.form_object
            page.form do |form|
              # form.caption 'Resource'
              form.view_only!
              form.add_field :resource_type_id
              form.add_field :system_resource_id
              form.add_field :resource_code
              form.add_field :description
              form.add_field :resource_attributes
              form.add_field :active
            end
          end

          layout
        end
      end
    end
  end
end
