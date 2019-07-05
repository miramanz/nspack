# frozen_string_literal: true

module UiRules
  class ResourceTypeRule < Base
    def generate_rules
      @repo = ProductionApp::ResourceRepo.new
      make_form_object
      apply_form_values

      common_values_for_fields common_fields

      set_show_fields if %i[show reopen].include? @mode

      form_name 'resource_type'
    end

    def set_show_fields
      fields[:resource_type_code] = { renderer: :label }
      fields[:description] = { renderer: :label }
      fields[:attribute_rules] = { renderer: :label }
      fields[:behaviour_rules] = { renderer: :label }
      fields[:active] = { renderer: :label, as_boolean: true }
    end

    def common_fields
      {
        resource_type_code: { required: true },
        description: { required: true },
        attribute_rules: {},
        behaviour_rules: {}
      }
    end

    def make_form_object
      if @mode == :new
        make_new_form_object
        return
      end

      @form_object = @repo.find_resource_type(@options[:id])
    end

    def make_new_form_object
      @form_object = OpenStruct.new(resource_type_code: nil,
                                    description: nil,
                                    attribute_rules: nil,
                                    behaviour_rules: nil)
    end
  end
end
