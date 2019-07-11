# frozen_string_literal: true

module UiRules
  class FarmRule < Base
    def generate_rules
      @repo = MasterfilesApp::FarmRepo.new
      make_form_object
      apply_form_values

      common_values_for_fields common_fields

      set_show_fields if %i[show reopen].include? @mode

      # add_behaviours if @options[:id]

      form_name 'farm'
    end

    def set_show_fields
      owner_party_role_id_label = MasterfilesApp::PartyRepo.new.find_party_role(@form_object.owner_party_role_id)&.party_name
      pdn_region_id_label = @repo.find(:production_regions, MasterfilesApp::ProductionRegion, @form_object.pdn_region_id)&.production_region_code
      farm_group_id_label = @repo.find(:farm_groups, MasterfilesApp::FarmGroup, @form_object.farm_group_id)&.farm_group_code
      fields[:owner_party_role_id] = { renderer: :label, with_value: owner_party_role_id_label, caption: 'Owner Party Role' }
      fields[:pdn_region_id] = { renderer: :label, with_value: pdn_region_id_label, caption: 'Pdn Region' }
      fields[:farm_group_id] = { renderer: :label, with_value: farm_group_id_label, caption: 'Farm Group' }
      fields[:farm_code] = { renderer: :label }
      fields[:description] = { renderer: :label }
      fields[:active] = { renderer: :label, as_boolean: true }
    end

    def common_fields
      {
        owner_party_role_id: { renderer: :select, options: MasterfilesApp::PartyRepo.new.for_select_party_roles, caption: 'owner_party_role', required: true },
        pdn_region_id: { renderer: :select, options: MasterfilesApp::FarmRepo.new.for_select_production_regions, disabled_options: MasterfilesApp::FarmRepo.new.for_select_inactive_production_regions, caption: 'pdn_region', required: true },
        farm_group_id: { renderer: :select, options: MasterfilesApp::FarmRepo.new.for_select_farm_groups, disabled_options: MasterfilesApp::FarmRepo.new.for_select_inactive_farm_groups, caption: 'farm_group', required: true },
        farm_code: { required: true },
        description: {}
      }
    end

    def make_form_object
      if @mode == :new
        make_new_form_object
        return
      end

      @form_object = @repo.find_farm(@options[:id])
    end

    def make_new_form_object
      @form_object = OpenStruct.new(owner_party_role_id: nil,
                                    pdn_region_id: nil,
                                    farm_group_id: nil,
                                    farm_code: nil,
                                    description: nil)
    end

    def add_behaviours
      behaviours do |behaviour|
        behaviour.dropdown_change :owner_party_role_id, notify: [{ url: "/masterfiles/farms/farms/#{@options[:id]}/owner_party_role_changed" }]
      end
    end

  end
end
