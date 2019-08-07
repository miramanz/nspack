# frozen_string_literal: true

class Nspack < Roda
  route 'marketing', 'masterfiles' do |r| # rubocop:disable Metrics/BlockLength
    # MARKS
    # --------------------------------------------------------------------------
    r.on 'marks', Integer do |id| # rubocop:disable Metrics/BlockLength
      interactor = MasterfilesApp::MarkInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:marks, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('marketing', 'edit')
        interactor.assert_permission!(:edit, id)
        show_partial { Masterfiles::Marketing::Mark::Edit.call(id) }
      end

      r.is do
        r.get do       # SHOW
          check_auth!('marketing', 'read')
          show_partial { Masterfiles::Marketing::Mark::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_mark(id, params[:mark])
          if res.success
            update_grid_row(id, changes: { mark_code: res.instance[:mark_code], description: res.instance[:description] },
                                notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Marketing::Mark::Edit.call(id, form_values: params[:mark], form_errors: res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('marketing', 'delete')
          interactor.assert_permission!(:delete, id)
          res = interactor.delete_mark(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message, status: 200)
          end
        end
      end
    end

    r.on 'marks' do
      interactor = MasterfilesApp::MarkInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('marketing', 'new')
        show_partial_or_page(r) { Masterfiles::Marketing::Mark::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_mark(params[:mark])
        if res.success
          row_keys = %i[
            id
            mark_code
            description
            active
          ]
          add_grid_row(attrs: select_attributes(res.instance, row_keys),
                       notice: res.message)
        else
          re_show_form(r, res, url: '/masterfiles/marketing/marks/new') do
            Masterfiles::Marketing::Mark::New.call(form_values: params[:mark],
                                                   form_errors: res.errors,
                                                   remote: fetch?(r))
          end
        end
      end
    end
  end
end
