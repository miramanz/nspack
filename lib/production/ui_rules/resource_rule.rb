# frozen_string_literal: true

module UiRules
  class ResourceRule < Base
    def generate_rules
      @repo = ProductionApp::ResourceRepo.new
      make_form_object
      apply_form_values

      common_values_for_fields common_fields

      set_show_fields if %i[show reopen].include? @mode

      form_name 'resource'
    end

    def set_show_fields
      resource_type_id_label = @repo.find_resource_type(@form_object.resource_type_id)&.resource_type_code
      system_resource_id_label = @repo.find_resource(@form_object.system_resource_id)&.resource_code
      fields[:resource_type_id] = { renderer: :label, with_value: resource_type_id_label, caption: 'Resource Type' }
      fields[:system_resource_id] = { renderer: :label, with_value: system_resource_id_label, caption: 'System Resource' }
      fields[:resource_code] = { renderer: :label }
      fields[:description] = { renderer: :label }
      fields[:resource_attributes] = { renderer: :label }
      fields[:active] = { renderer: :label, as_boolean: true }
    end

    def common_fields
      {
        resource_type_id: { renderer: :select,
                            options: @repo.for_select_resource_types,
                            disabled_options: @repo.for_select_inactive_resource_types,
                            caption: 'resource_type', required: true },
        system_resource_id: { renderer: :select,
                              options: @repo.for_select_resources,
                              disabled_options: @repo.for_select_inactive_resources,
                              caption: 'system_resource' },
        resource_code: { required: true },
        description: { required: true },
        resource_attributes: {}
      }
    end

    def make_form_object
      if @mode == :new
        make_new_form_object
        return
      end

      @form_object = @repo.find_resource(@options[:id])
    end

    def make_new_form_object
      @form_object = OpenStruct.new(resource_type_id: nil,
                                    system_resource_id: nil,
                                    resource_code: nil,
                                    description: nil,
                                    resource_attributes: nil)
    end
  end
end
