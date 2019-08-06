# frozen_string_literal: true

module Production
  module Resources
    module PlantResource
      class NewSystemResource
        def self.call(id:, plant_resource: nil, form_values: nil, form_errors: nil, remote: true) # rubocop:disable Metrics/AbcSize
          ui_rule = UiRules::Compiler.new(:resource, :new_system, parent_id: id, plant_resource: plant_resource, form_values: form_values)
          rules   = ui_rule.compile

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object ui_rule.form_object
            page.form_values form_values
            page.form_errors form_errors
            page.form do |form|
              form.caption 'New Resource - 2nd part'
              form.action "/production/resources/resources/#{id}/add_system_child"
              form.remote! if remote
              form.add_field :resource_type_id
              # form.add_field :system_resource_id
              form.add_field :resource_code
              form.add_field :description
              form.add_field :ip_address
              # form.add_field :resource_attributes
            end
          end

          layout
        end
      end
    end
  end
end
