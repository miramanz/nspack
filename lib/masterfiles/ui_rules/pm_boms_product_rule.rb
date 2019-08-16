# frozen_string_literal: true

module UiRules
  class PmBomsProductRule < Base
    def generate_rules
      @repo = MasterfilesApp::BomsRepo.new
      make_form_object
      apply_form_values

      common_values_for_fields common_fields

      set_show_fields if %i[show reopen].include? @mode

      form_name 'pm_boms_product'
    end

    def set_show_fields
      pm_product_id_label = @repo.find_hash(:pm_products,  @form_object.pm_product_id)[:erp_code]
      pm_bom_id_label = @repo.find_hash(:pm_boms, @form_object.pm_bom_id)[:bom_code]
      unit_of_measure_id_label = @repo.find_hash(:units_of_measure, @form_object.unit_of_measure_id)[:unit_of_measure]
      fields[:pm_product_id] = { renderer: :label, with_value: pm_product_id_label, caption: 'Pm Product' }
      fields[:pm_bom_id] = { renderer: :label, with_value: pm_bom_id_label, caption: 'Pm Bom' }
      fields[:unit_of_measure_id] = { renderer: :label, with_value: unit_of_measure_id_label, caption: 'Unit Of Measure' }
      fields[:quantity] = { renderer: :label }
    end

    def common_fields
      pm_bom_id = @options[:pm_bom_id] || @repo.find_pm_boms_product(@options[:id]).pm_bom_id
      pm_bom_id_label = @repo.find_pm_bom(pm_bom_id)&.bom_code
      {
        pm_bom_id: { renderer: :hidden, value: pm_bom_id },
        pm_bom: { renderer: :label, with_value: pm_bom_id_label, caption: 'PM Bom', readonly: true },
        pm_product_id: { renderer: :select,
                         options: @repo.for_select_pm_products,
                         disabled_options: @repo.for_select_inactive_pm_products,
                         caption: 'pm_product',
                         required: true },
        unit_of_measure_id: { renderer: :select,
                              options: @repo.for_select_units_of_measure,
                              disabled_options: @repo.for_select_inactive_units_of_measure,
                              caption: 'unit_of_measure',
                              required: true },
        quantity: { renderer: :number, required: true }
      }
    end

    def make_form_object
      if @mode == :new
        make_new_form_object
        return
      end

      @form_object = @repo.find_pm_boms_product(@options[:id])
    end

    def make_new_form_object
      @form_object = OpenStruct.new(pm_bom_id: @options[:pm_bom_id],
                                    pm_product_id: nil,
                                    unit_of_measure_id: nil,
                                    quantity: nil)
    end
  end
end
