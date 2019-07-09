# frozen_string_literal: true

module Production
  module Resources
    module Resource
      class New
        def self.call(id: nil, form_values: nil, form_errors: nil, remote: true) # rubocop:disable Metrics/AbcSize
          ui_rule = UiRules::Compiler.new(:resource, :new, parent_id: id, form_values: form_values)
          rules   = ui_rule.compile

          action = id.nil? ? '/production/resources/resources' : "/production/resources/resources/#{id}/add_child"

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object ui_rule.form_object
            page.form_values form_values
            page.form_errors form_errors
            page.form do |form|
              form.caption 'New Resource'
              form.action action
              form.remote! if remote
              form.add_field :resource_type_id
              # form.add_field :system_resource_id
              form.add_field :resource_code
              form.add_field :description
              # form.add_field :resource_attributes
            end
          end

          layout
        end
      end
    end
  end
end
