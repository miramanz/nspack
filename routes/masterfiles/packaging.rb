# frozen_string_literal: true

class Nspack < Roda # rubocop:disable Metrics/ClassLength
  route 'packaging', 'masterfiles' do |r| # rubocop:disable Metrics/BlockLength
    # PALLET BASES
    # --------------------------------------------------------------------------
    r.on 'pallet_bases', Integer do |id| # rubocop:disable Metrics/BlockLength
      interactor = MasterfilesApp::PalletBaseInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:pallet_bases, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('packaging', 'edit')
        interactor.assert_permission!(:edit, id)
        show_partial { Masterfiles::Packaging::PalletBase::Edit.call(id) }
      end

      r.is do # rubocop:disable Metrics/BlockLength
        r.get do       # SHOW
          check_auth!('packaging', 'read')
          show_partial { Masterfiles::Packaging::PalletBase::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_pallet_base(id, params[:pallet_base])
          if res.success
            row_keys = %i[
              pallet_base_code
              description
              length
              width
              edi_in_pallet_base
              edi_out_pallet_base
              cartons_per_layer
              active
            ]
            update_grid_row(id, changes: select_attributes(res.instance, row_keys), notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Packaging::PalletBase::Edit.call(id, form_values: params[:pallet_base], form_errors: res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('packaging', 'delete')
          interactor.assert_permission!(:delete, id)
          res = interactor.delete_pallet_base(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message, status: 200)
          end
        end
      end
    end

    r.on 'pallet_bases' do # rubocop:disable Metrics/BlockLength
      interactor = MasterfilesApp::PalletBaseInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('packaging', 'new')
        show_partial_or_page(r) { Masterfiles::Packaging::PalletBase::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_pallet_base(params[:pallet_base])
        if res.success
          row_keys = %i[
            id
            pallet_base_code
            description
            length
            width
            edi_in_pallet_base
            edi_out_pallet_base
            cartons_per_layer
            active
          ]
          add_grid_row(attrs: select_attributes(res.instance, row_keys),
                       notice: res.message)
        else
          re_show_form(r, res, url: '/masterfiles/packaging/pallet_bases/new') do
            Masterfiles::Packaging::PalletBase::New.call(form_values: params[:pallet_base],
                                                         form_errors: res.errors,
                                                         remote: fetch?(r))
          end
        end
      end
    end

    # PALLET STACK TYPES
    # --------------------------------------------------------------------------
    r.on 'pallet_stack_types', Integer do |id| # rubocop:disable Metrics/BlockLength
      interactor = MasterfilesApp::PalletStackTypeInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:pallet_stack_types, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('packaging', 'edit')
        interactor.assert_permission!(:edit, id)
        show_partial { Masterfiles::Packaging::PalletStackType::Edit.call(id) }
      end

      r.is do
        r.get do       # SHOW
          check_auth!('packaging', 'read')
          show_partial { Masterfiles::Packaging::PalletStackType::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_pallet_stack_type(id, params[:pallet_stack_type])
          if res.success
            update_grid_row(id, changes: { stack_type_code: res.instance[:stack_type_code], description: res.instance[:description], stack_height: res.instance[:stack_height] },
                                notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Packaging::PalletStackType::Edit.call(id, form_values: params[:pallet_stack_type], form_errors: res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('packaging', 'delete')
          interactor.assert_permission!(:delete, id)
          res = interactor.delete_pallet_stack_type(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message, status: 200)
          end
        end
      end
    end

    r.on 'pallet_stack_types' do
      interactor = MasterfilesApp::PalletStackTypeInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('packaging', 'new')
        show_partial_or_page(r) { Masterfiles::Packaging::PalletStackType::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_pallet_stack_type(params[:pallet_stack_type])
        if res.success
          row_keys = %i[
            id
            stack_type_code
            description
            stack_height
            active
          ]
          add_grid_row(attrs: select_attributes(res.instance, row_keys),
                       notice: res.message)
        else
          re_show_form(r, res, url: '/masterfiles/packaging/pallet_stack_types/new') do
            Masterfiles::Packaging::PalletStackType::New.call(form_values: params[:pallet_stack_type],
                                                              form_errors: res.errors,
                                                              remote: fetch?(r))
          end
        end
      end
    end
  end
end
