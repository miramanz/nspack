# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

class Nspack < Roda # rubocop:disable Metrics/ClassLength
  route 'farms', 'masterfiles' do |r|
    # PRODUCTION REGIONS
    # --------------------------------------------------------------------------
    r.on 'production_regions', Integer do |id|
      interactor = MasterfilesApp::ProductionRegionInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:production_regions, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('farms', 'edit')
        interactor.assert_permission!(:edit, id)
        show_partial { Masterfiles::Farms::ProductionRegion::Edit.call(id) }
      end

      r.is do
        r.get do       # SHOW
          check_auth!('farms', 'read')
          show_partial { Masterfiles::Farms::ProductionRegion::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_production_region(id, params[:production_region])
          if res.success
            update_grid_row(id, changes: { production_region_code: res.instance[:production_region_code], description: res.instance[:description] }, notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Farms::ProductionRegion::Edit.call(id, form_values: params[:production_region], form_errors: res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('farms', 'delete')
          interactor.assert_permission!(:delete, id)
          res = interactor.delete_production_region(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message, status: 200)
          end
        end
      end
    end

    r.on 'production_regions' do
      interactor = MasterfilesApp::ProductionRegionInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('farms', 'new')
        show_partial_or_page(r) { Masterfiles::Farms::ProductionRegion::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_production_region(params[:production_region])
        if res.success
          row_keys = %i[
            id
            production_region_code
            description
          ]
          add_grid_row(attrs: select_attributes(res.instance, row_keys),
                       notice: res.message)
        else
          re_show_form(r, res, url: '/masterfiles/farms/production_regions/new') do
            Masterfiles::Farms::ProductionRegion::New.call(form_values: params[:production_region],
                                                           form_errors: res.errors,
                                                           remote: fetch?(r))
          end
        end
      end
    end

    # FARM GROUPS
    # --------------------------------------------------------------------------
    r.on 'farm_groups', Integer do |id|
      interactor = MasterfilesApp::FarmGroupInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:farm_groups, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('farms', 'edit')
        interactor.assert_permission!(:edit, id)
        show_partial { Masterfiles::Farms::FarmGroup::Edit.call(id) }
      end

      r.is do
        r.get do       # SHOW
          check_auth!('farms', 'read')
          show_partial { Masterfiles::Farms::FarmGroup::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_farm_group(id, params[:farm_group])
          if res.success
            update_grid_row(id, changes: { owner_party_role_id: res.instance[:owner_party_role_id], farm_group_code: res.instance[:farm_group_code], description: res.instance[:description] }, notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Farms::FarmGroup::Edit.call(id, form_values: params[:farm_group], form_errors: res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('farms', 'delete')
          interactor.assert_permission!(:delete, id)
          res = interactor.delete_farm_group(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message, status: 200)
          end
        end
      end
    end

    r.on 'farm_groups' do
      interactor = MasterfilesApp::FarmGroupInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('farms', 'new')
        show_partial_or_page(r) { Masterfiles::Farms::FarmGroup::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_farm_group(params[:farm_group])
        if res.success
          row_keys = %i[
            id
            owner_party_role_id
            farm_group_code
            description
            active
          ]
          add_grid_row(attrs: select_attributes(res.instance, row_keys),
                       notice: res.message)
        else
          re_show_form(r, res, url: '/masterfiles/farms/farm_groups/new') do
            Masterfiles::Farms::FarmGroup::New.call(form_values: params[:farm_group],
                                                    form_errors: res.errors,
                                                    remote: fetch?(r))
          end
        end
      end
    end

    # FARMS
    r.on 'farms', Integer do |id|
      interactor = MasterfilesApp::FarmInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:farms, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('farms', 'edit')
        interactor.assert_permission!(:edit, id)
        show_partial { Masterfiles::Farms::Farm::Edit.call(id) }
      end

      r.on 'owner_party_role_changed' do
        farm_groups = interactor.selected_farm_groups(params[:changed_value])
        json_replace_select_options('farm_farm_group_id', farm_groups)
      end

      r.on 'list_farm_orchards' do
        check_auth!('farms', 'edit')
        r.redirect "/list/orchards/with_params?key=standard&orchards.farm_id=#{id}"
      end

      r.on 'link_farm_pucs' do
        r.post do
          res = interactor.associate_farms_pucs(id, multiselect_grid_choices(params))
          if fetch?(r)
            show_json_notice(res.message)
          else
            flash[:notice] = res.message
            r.redirect '/list/pucs'
          end
        end
      end

      r.on 'orchards' do
        interactor = MasterfilesApp::OrchardInteractor.new(current_user, {}, { route_url: request.path }, {})
        r.on 'add_orchards' do
          check_auth!('farms', 'new')
          show_partial_or_page(r) { Masterfiles::Farms::Orchard::New.call(id, remote: fetch?(r)) }
        end

        r.post do        # CREATE
          res = interactor.create_orchard(params[:orchard])
          if res.success
            row_keys = %i[
              id
              farm_id
              puc_id
              orchard_code
              description
              active
              cultivar_ids
              puc_code
              cultivar_names
            ]
            add_grid_row(attrs: select_attributes(res.instance, row_keys),
                         notice: res.message)
          else
            re_show_form(r, res, url: "/masterfiles/farms/farms/#{id}/orchards/add_orchards") do
              Masterfiles::Farms::Orchard::New.call(id,
                                                    form_values: params[:orchard],
                                                    form_errors: res.errors,
                                                    remote: fetch?(r))
            end
          end
        end
      end

      r.is do
        r.get do       # SHOW
          check_auth!('farms', 'read')
          show_partial { Masterfiles::Farms::Farm::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_farm(id, params[:farm])
          if res.success
            row_keys = %i[
              owner_party_role_id
              pdn_region_id
              farm_group_id
              farm_code
              description
              puc_id
              farm_group_code
              owner_party_role
              pdn_region_production_region_code
              active
            ]
            update_grid_row(id, changes: select_attributes(res.instance, row_keys), notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Farms::Farm::Edit.call(id, form_values: params[:farm], form_errors: res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('farms', 'delete')
          interactor.assert_permission!(:delete, id)
          res = interactor.delete_farm(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message, status: 200)
          end
        end
      end
    end
    r.on 'farms' do
      interactor = MasterfilesApp::FarmInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('farms', 'new')
        show_partial_or_page(r) { Masterfiles::Farms::Farm::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_farm(params[:farm])
        if res.success
          row_keys = %i[
            id
            owner_party_role_id
            pdn_region_id
            farm_group_id
            farm_code
            description
            farm_group_code
            owner_party_role
            pdn_region_production_region_code
            active
          ]
          add_grid_row(attrs: select_attributes(res.instance, row_keys),
                       notice: res.message)
        else
          re_show_form(r, res, url: '/masterfiles/farms/farms/new') do
            Masterfiles::Farms::Farm::New.call(form_values: params[:farm],
                                               form_errors: res.errors,
                                               remote: fetch?(r))
          end
        end
      end
    end
    # ORCHARDS
    r.on 'orchards', Integer do |id|
      interactor = MasterfilesApp::OrchardInteractor.new(current_user, {}, { route_url: request.path }, {})
      # Check for notfound:
      r.on !interactor.exists?(:orchards, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('farms', 'edit')
        interactor.assert_permission!(:edit, id)
        show_partial { Masterfiles::Farms::Orchard::Edit.call(id) }
      end

      r.on 'farm_changed' do
        farm_pucs = interactor.selected_farm_pucs(params[:changed_value])
        json_replace_select_options('orchard_puc_id', farm_pucs)
      end

      r.is do
        r.get do       # SHOW
          check_auth!('farms', 'read')
          show_partial { Masterfiles::Farms::Orchard::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_orchard(id, params[:orchard])
          if res.success
            row_keys = %i[
              farm_id
              puc_id
              orchard_code
              description
              active
              cultivar_ids
              puc_code
              cultivar_names
            ]
            update_grid_row(id, changes: select_attributes(res.instance, row_keys), notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Farms::Orchard::Edit.call(id, form_values: params[:orchard], form_errors: res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('farms', 'delete')
          interactor.assert_permission!(:delete, id)
          res = interactor.delete_orchard(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message, status: 200)
          end
        end
      end
    end

    # PUCS
    r.on 'pucs', Integer do |id|
      interactor = MasterfilesApp::PucInteractor.new(current_user, {}, { route_url: request.path }, {})
      # Check for notfound:
      r.on !interactor.exists?(:pucs, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('farms', 'edit')
        interactor.assert_permission!(:edit, id)
        show_partial { Masterfiles::Farms::Puc::Edit.call(id) }
      end

      r.is do
        r.get do       # SHOW
          check_auth!('farms', 'read')
          show_partial { Masterfiles::Farms::Puc::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_puc(id, params[:puc])
          if res.success
            update_grid_row(id, changes: { puc_code: res.instance[:puc_code], gap_code: res.instance[:gap_code] }, notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Farms::Puc::Edit.call(id, form_values: params[:puc], form_errors: res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('farms', 'delete')
          interactor.assert_permission!(:delete, id)
          res = interactor.delete_puc(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message, status: 200)
          end
        end
      end
    end

    r.on 'pucs' do
      interactor = MasterfilesApp::PucInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('farms', 'new')
        show_partial_or_page(r) { Masterfiles::Farms::Puc::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_puc(params[:puc])
        if res.success
          row_keys = %i[
            id
            puc_code
            gap_code
            active
          ]
          add_grid_row(attrs: select_attributes(res.instance, row_keys),
                       notice: res.message)
        else
          re_show_form(r, res, url: '/masterfiles/farms/pucs/new') do
            Masterfiles::Farms::Puc::New.call(form_values: params[:puc],
                                              form_errors: res.errors,
                                              remote: fetch?(r))
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
