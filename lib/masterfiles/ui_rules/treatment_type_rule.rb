# frozen_string_literal: true

module UiRules
  class TreatmentTypeRule < Base
    def generate_rules
      @repo = MasterfilesApp::FruitRepo.new
      make_form_object
      apply_form_values

      common_values_for_fields common_fields

      set_show_fields if %i[show reopen].include? @mode

      form_name 'treatment_type'
    end

    def set_show_fields
      fields[:treatment_type_code] = { renderer: :label }
      fields[:description] = { renderer: :label }
      fields[:active] = { renderer: :label, as_boolean: true }
      fields[:treatments] = { renderer: :list, items: treatment_type_treatments }
    end

    def common_fields
      {
        treatment_type_code: { required: true },
        description: {}
      }
    end

    def make_form_object
      if @mode == :new
        make_new_form_object
        return
      end

      @form_object = @repo.find_treatment_type(@options[:id])
    end

    def make_new_form_object
      @form_object = OpenStruct.new(treatment_type_code: nil,
                                    description: nil)
    end

    def treatment_type_treatments
      @repo.find_treatment_type_treatment_codes(@options[:id])
    end
  end
end
