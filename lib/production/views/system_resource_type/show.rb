# frozen_string_literal: true

module Production
  module Resources
    module SystemResourceType
      class Show
        def self.call(id)
          ui_rule = UiRules::Compiler.new(:system_resource_type, :show, id: id)
          rules   = ui_rule.compile

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object ui_rule.form_object
            page.form do |form|
              # form.caption 'System Resource Type'
              form.view_only!
              form.add_field :system_resource_type_code
              form.add_field :description
              # form.add_field :icon
              form.add_text rules[:icon_render]
              form.add_field :active
            end
          end

          layout
        end
      end
    end
  end
end
