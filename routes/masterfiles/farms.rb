# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

class Nspack < Roda
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
            update_grid_row(id, changes: { production_region_code: res.instance[:production_region_code], description: res.instance[:description] },
                                notice: res.message)
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
  end
end

# rubocop:enable Metrics/BlockLength
