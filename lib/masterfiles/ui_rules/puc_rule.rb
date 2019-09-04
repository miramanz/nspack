# frozen_string_literal: true

module UiRules
  class PucRule < Base
    def generate_rules
      @repo = MasterfilesApp::FarmRepo.new
      make_form_object
      apply_form_values

      common_values_for_fields common_fields

      set_show_fields if %i[show reopen].include? @mode

      form_name 'puc'
    end

    def set_show_fields
      fields[:puc_code] = { renderer: :label }
      fields[:gap_code] = { renderer: :label }
      fields[:active] = { renderer: :label, as_boolean: true }
      fields[:farms] = { renderer: :list, items: puc_farm_codes }
    end

    def common_fields
      {
        puc_code: { required: true },
        gap_code: {},
        active: { renderer: :checkbox }
      }
    end

    def make_form_object
      if @mode == :new
        make_new_form_object
        return
      end

      @form_object = @repo.find_puc(@options[:id])
    end

    def make_new_form_object
      @form_object = OpenStruct.new(puc_code: nil,
                                    gap_code: nil,
                                    active: true)
    end

    def puc_farm_codes
      @repo.find_puc_farm_codes(@options[:id])
    end
  end
end
