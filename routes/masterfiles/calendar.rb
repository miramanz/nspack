# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
class Nspack < Roda
  route 'calendar', 'masterfiles' do |r|
    # SEASON GROUPS
    # --------------------------------------------------------------------------
    r.on 'season_groups', Integer do |id|
      interactor = MasterfilesApp::SeasonGroupInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:season_groups, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('calendar', 'edit')
        interactor.assert_permission!(:edit, id)
        show_partial { Masterfiles::Calendar::SeasonGroup::Edit.call(id) }
      end

      # r.on 'complete' do
      #   r.get do
      #     check_auth!('calendar', 'edit')
      #     interactor.assert_permission!(:complete, id)
      #     show_partial { Masterfiles::Calendar::SeasonGroup::Complete.call(id) }
      #   end

      #   r.post do
      #     res = interactor.complete_a_season_group(id, params[:season_group])
      #     if res.success
      #       flash[:notice] = res.message
      #       redirect_to_last_grid(r)
      #     else
      #       re_show_form(r, res) { Masterfiles::Calendar::SeasonGroup::Complete.call(id, params[:season_group], res.errors) }
      #     end
      #   end
      # end

      # r.on 'approve' do
      #   r.get do
      #     check_auth!('calendar', 'approve')
      #     interactor.assert_permission!(:approve, id)
      #     show_partial { Masterfiles::Calendar::SeasonGroup::Approve.call(id) }
      #   end

      #   r.post do
      #     res = interactor.approve_or_reject_a_season_group(id, params[:season_group])
      #     if res.success
      #       flash[:notice] = res.message
      #       redirect_to_last_grid(r)
      #     else
      #       re_show_form(r, res) { Masterfiles::Calendar::SeasonGroup::Approve.call(id, params[:season_group], res.errors) }
      #     end
      #   end
      # end

      # r.on 'reopen' do
      #   r.get do
      #     check_auth!('calendar', 'edit')
      #     interactor.assert_permission!(:reopen, id)
      #     show_partial { Masterfiles::Calendar::SeasonGroup::Reopen.call(id) }
      #   end

      #   r.post do
      #     res = interactor.reopen_a_season_group(id, params[:season_group])
      #     if res.success
      #       flash[:notice] = res.message
      #       redirect_to_last_grid(r)
      #     else
      #       re_show_form(r, res) { Masterfiles::Calendar::SeasonGroup::Reopen.call(id, params[:season_group], res.errors) }
      #     end
      #   end
      # end

      r.is do
        r.get do       # SHOW
          check_auth!('calendar', 'read')
          show_partial { Masterfiles::Calendar::SeasonGroup::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_season_group(id, params[:season_group])
          if res.success
            update_grid_row(id, changes: { season_group_code: res.instance[:season_group_code], description: res.instance[:description], season_group_year: res.instance[:season_group_year] },
                                notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Calendar::SeasonGroup::Edit.call(id, form_values: params[:season_group], form_errors: res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('calendar', 'delete')
          interactor.assert_permission!(:delete, id)
          res = interactor.delete_season_group(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message, status: 200)
          end
        end
      end
    end

    r.on 'season_groups' do
      interactor = MasterfilesApp::SeasonGroupInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('calendar', 'new')
        show_partial_or_page(r) { Masterfiles::Calendar::SeasonGroup::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_season_group(params[:season_group])
        if res.success
          row_keys = %i[
            id
            season_group_code
            description
            season_group_year
          ]
          add_grid_row(attrs: select_attributes(res.instance, row_keys),
                       notice: res.message)
        else
          re_show_form(r, res, url: '/masterfiles/calendar/season_groups/new') do
            Masterfiles::Calendar::SeasonGroup::New.call(form_values: params[:season_group],
                                                         form_errors: res.errors,
                                                         remote: fetch?(r))
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
