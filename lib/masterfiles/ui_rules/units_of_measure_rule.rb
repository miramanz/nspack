# frozen_string_literal: true

module UiRules
  class UnitsOfMeasureRule < Base
    def generate_rules
      @repo = MasterfilesApp::BomsRepo.new
      make_form_object
      apply_form_values

      common_values_for_fields common_fields

      set_show_fields if %i[show reopen].include? @mode

      form_name 'units_of_measure'
    end

    def set_show_fields
      fields[:unit_of_measure] = { renderer: :label }
      fields[:description] = { renderer: :label }
      fields[:active] = { renderer: :label, as_boolean: true }
    end

    def common_fields
      {
        unit_of_measure: { required: true },
        description: {}
      }
    end

    def make_form_object
      if @mode == :new
        make_new_form_object
        return
      end

      @form_object = @repo.find_units_of_measure(@options[:id])
    end

    def make_new_form_object
      @form_object = OpenStruct.new(unit_of_measure: nil,
                                    description: nil)
    end
  end
end
