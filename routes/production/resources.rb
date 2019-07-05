# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
class Nspack < Roda # rubocop:disable Metrics/ClassLength
  route 'resources', 'production' do |r|
    # RESOURCE TYPES
    # --------------------------------------------------------------------------
    r.on 'resource_types', Integer do |id|
      interactor = ProductionApp::ResourceTypeInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:resource_types, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('resources', 'edit')
        # interactor.assert_permission!(:edit, id)
        show_partial { Production::Resources::ResourceType::Edit.call(id) }
      end

      r.is do
        r.get do       # SHOW
          check_auth!('resources', 'read')
          show_partial { Production::Resources::ResourceType::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_resource_type(id, params[:resource_type])
          if res.success
            row_keys = %i[
              resource_type_code
              description
              attribute_rules
              behaviour_rules
            ]
            update_grid_row(id, changes: select_attributes(res.instance, row_keys), notice: res.message)
          else
            re_show_form(r, res) { Production::Resources::ResourceType::Edit.call(id, form_values: params[:resource_type], form_errors: res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('resources', 'delete')
          # interactor.assert_permission!(:delete, id)
          res = interactor.delete_resource_type(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message, status: 200)
          end
        end
      end
    end

    r.on 'resource_types' do
      interactor = ProductionApp::ResourceTypeInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('resources', 'new')
        show_partial_or_page(r) { Production::Resources::ResourceType::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_resource_type(params[:resource_type])
        if res.success
          row_keys = %i[
            id
            resource_type_code
            description
            attribute_rules
            behaviour_rules
          ]
          add_grid_row(attrs: select_attributes(res.instance, row_keys),
                       notice: res.message)
        else
          re_show_form(r, res, url: '/production/resources/resource_types/new') do
            Production::Resources::ResourceType::New.call(form_values: params[:resource_type],
                                                          form_errors: res.errors,
                                                          remote: fetch?(r))
          end
        end
      end
    end

    # RESOURCES
    # --------------------------------------------------------------------------
    r.on 'resources', Integer do |id|
      interactor = ProductionApp::ResourceInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:resources, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('resources', 'edit')
        # interactor.assert_permission!(:edit, id)
        show_partial { Production::Resources::Resource::Edit.call(id) }
      end

      r.on 'add_child' do   # NEW CHILD
        r.get do
          check_auth!('resources', 'edit')
          show_partial { Production::Resources::Resource::New.call(id: id) }
        end
        r.post do
          res = interactor.create_resource(id, params[:resource])
          if res.success
            flash[:notice] = res.message
            redirect_to_last_grid(r)
          else
            # form_errors = move_validation_errors_to_base(res.errors, :location_long_code, highlights: { location_long_code: %i[location_long_code location_short_code] })
            # form_errors2 = move_validation_errors_to_base(form_errors, :receiving_bay_type_location, highlights: { receiving_bay_type_location: %i[location_type_id can_store_stock] })
            re_show_form(r, res, url: "/production/resources/resources/#{id}/add_child") do
              Production::Resources::Resource::New.call(id: id,
                                                        form_values: params[:resource],
                                                        form_errors: res.errors,
                                                        remote: fetch?(r))
            end
          end
        end
      end
      r.is do
        r.get do       # SHOW
          check_auth!('resources', 'read')
          show_partial { Production::Resources::Resource::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_resource(id, params[:resource])
          if res.success
            row_keys = %i[
              resource_type_id
              system_resource_id
              resource_code
              description
              resource_attributes
            ]
            update_grid_row(id, changes: select_attributes(res.instance, row_keys), notice: res.message)
          else
            re_show_form(r, res) { Production::Resources::Resource::Edit.call(id, form_values: params[:resource], form_errors: res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('resources', 'delete')
          # interactor.assert_permission!(:delete, id)
          res = interactor.delete_resource(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message, status: 200)
          end
        end
      end
    end

    r.on 'resources' do
      interactor = ProductionApp::ResourceInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('resources', 'new')
        show_partial_or_page(r) { Production::Resources::Resource::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_root_resource(params[:resource])
        if res.success # resource_type_code
          row_keys = %i[
            id
            resource_type_id
            system_resource_id
            resource_code
            description
            resource_attributes
          ]
          add_grid_row(attrs: select_attributes(res.instance, row_keys),
                       notice: res.message)
        else
          re_show_form(r, res, url: '/production/resources/resources/new') do
            Production::Resources::Resource::New.call(form_values: params[:resource],
                                                      form_errors: res.errors,
                                                      remote: fetch?(r))
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
