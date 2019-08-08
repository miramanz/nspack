# frozen_string_literal: true

module UiRules
  class SystemResourceTypeRule < Base
    def generate_rules
      @repo = ProductionApp::ResourceRepo.new
      make_form_object
      apply_form_values

      common_values_for_fields common_fields

      set_show_fields if %i[show reopen].include? @mode

      form_name 'system_resource_type'
    end

    def set_show_fields
      fields[:system_resource_type_code] = { renderer: :label }
      fields[:description] = { renderer: :label }
      fields[:computing_device] = { renderer: :label, as_boolean: true }
      fields[:peripheral] = { renderer: :label, as_boolean: true }
      fields[:active] = { renderer: :label, as_boolean: true }
      rules[:icon_render] = render_icon(@form_object.icon)
    end

    def common_fields
      {
        system_resource_type_code: { required: true },
        description: { required: true },
        computing_device: { renderer: :checkbox },
        peripheral: { renderer: :checkbox },
        icon: {}
      }
    end

    def make_form_object
      @form_object = @repo.find_system_resource_type(@options[:id])
    end
  end
end
