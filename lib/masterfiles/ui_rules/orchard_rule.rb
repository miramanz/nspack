# frozen_string_literal: true

module UiRules
  class OrchardRule < Base
    def generate_rules
      @repo = MasterfilesApp::FarmRepo.new
      make_form_object
      apply_form_values

      common_values_for_fields common_fields

      set_show_fields if %i[show reopen].include? @mode

      add_behaviours if @options[:id]

      form_name 'orchard'
    end

    def set_show_fields
      farm_id_label = MasterfilesApp::FarmRepo.new.find_farm(@form_object.farm_id)&.farm_code
      puc_id_label = MasterfilesApp::FarmRepo.new.find_puc(@form_object.puc_id)&.puc_code
      fields[:farm_id] = { renderer: :label, with_value: farm_id_label, caption: 'Farm' }
      fields[:puc_id] = { renderer: :label, with_value: puc_id_label, caption: 'Puc' }
      fields[:orchard_code] = { renderer: :label }
      fields[:description] = { renderer: :label }
      fields[:cultivars] = { renderer: :label }
      fields[:active] = { renderer: :label, as_boolean: true }
    end

    def common_fields
      {
        farm_id: { renderer: :select, options: MasterfilesApp::FarmRepo.new.for_select_farms, disabled_options: MasterfilesApp::FarmRepo.new.for_select_inactive_farms, caption: 'farm', required: true },
        puc_id: { renderer: :select, options: MasterfilesApp::FarmRepo.new.for_select_pucs, disabled_options: MasterfilesApp::FarmRepo.new.for_select_inactive_pucs, caption: 'puc', required: true },
        orchard_code: { required: true },
        description: {},
        cultivars: {}
      }
    end

    def make_form_object
      if @mode == :new
        make_new_form_object
        return
      end

      @form_object = @repo.find_orchard(@options[:id])
    end

    def make_new_form_object
      @form_object = OpenStruct.new(farm_id: nil,
                                    puc_id: nil,
                                    orchard_code: nil,
                                    description: nil,
                                    cultivars: nil)
    end

    def add_behaviours
      behaviours do |behaviour|
        behaviour.dropdown_change :farm_id, notify: [{ url: "/masterfiles/farms/orchards/#{@options[:id]}/farm_changed" }]
      end
    end


  end
end
