# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/BlockLength

class Nspack < Roda
  route 'fruit', 'masterfiles' do |r|
    # COMMODITY GROUPS
    # --------------------------------------------------------------------------
    r.on 'commodity_groups', Integer do |id|
      interactor = MasterfilesApp::CommodityInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:commodity_groups, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('fruit', 'edit')
        show_partial { Masterfiles::Fruit::CommodityGroup::Edit.call(id) }
      end
      r.is do
        r.get do       # SHOW
          check_auth!('fruit', 'read')
          show_partial { Masterfiles::Fruit::CommodityGroup::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_commodity_group(id, params[:commodity_group])
          if res.success
            update_grid_row(id,
                            changes: { code: res.instance[:code],
                                       description: res.instance[:description] },
                            notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Fruit::CommodityGroup::Edit.call(id, params[:commodity_group], res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('fruit', 'delete')
          res = interactor.delete_commodity_group(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message)
          end
        end
      end
    end
    r.on 'commodity_groups' do
      interactor = MasterfilesApp::CommodityInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('fruit', 'new')
        show_partial_or_page(r) { Masterfiles::Fruit::CommodityGroup::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_commodity_group(params[:commodity_group])
        if res.success
          flash[:notice] = res.message
          redirect_to_last_grid(r)
        else
          re_show_form(r, res, url: '/masterfiles/fruit/commodity_groups/new') do
            Masterfiles::Fruit::CommodityGroup::New.call(form_values: params[:commodity_group],
                                                         form_errors: res.errors,
                                                         remote: fetch?(r))
          end
        end
      end
    end
    # COMMODITIES
    # --------------------------------------------------------------------------
    r.on 'commodities', Integer do |id|
      interactor = MasterfilesApp::CommodityInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:commodities, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('fruit', 'edit')
        show_partial { Masterfiles::Fruit::Commodity::Edit.call(id) }
      end
      r.is do
        r.get do       # SHOW
          check_auth!('fruit', 'read')
          show_partial { Masterfiles::Fruit::Commodity::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_commodity(id, params[:commodity])
          if res.success
            update_grid_row(id,
                            changes: { commodity_group_id: res.instance[:commodity_group_id],
                                       code: res.instance[:code],
                                       description: res.instance[:description],
                                       hs_code: res.instance[:hs_code] },
                            notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Fruit::Commodity::Edit.call(id, params[:commodity], res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('fruit', 'delete')
          res = interactor.delete_commodity(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message)
          end
        end
      end
    end
    r.on 'commodities' do
      interactor = MasterfilesApp::CommodityInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('fruit', 'new')
        show_partial_or_page(r) { Masterfiles::Fruit::Commodity::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_commodity(params[:commodity])
        if res.success
          flash[:notice] = res.message
          redirect_to_last_grid(r)
        else
          re_show_form(r, res, url: '/masterfiles/fruit/commodities/new') do
            Masterfiles::Fruit::Commodity::New.call(form_values: params[:commodity],
                                                    form_errors: res.errors,
                                                    remote: fetch?(r))
          end
        end
      end
    end
    # CULTIVAR GROUPS
    # --------------------------------------------------------------------------
    r.on 'cultivar_groups', Integer do |id|
      interactor = MasterfilesApp::CultivarInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:cultivar_groups, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('fruit', 'edit')
        show_partial { Masterfiles::Fruit::CultivarGroup::Edit.call(id) }
      end
      r.is do
        r.get do       # SHOW
          check_auth!('fruit', 'read')
          show_partial { Masterfiles::Fruit::CultivarGroup::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_cultivar_group(id, params[:cultivar_group])
          if res.success
            update_grid_row(id,
                            changes: { cultivar_group_code: res.instance[:cultivar_group_code],
                                       description: res.instance[:description] },
                            notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Fruit::CultivarGroup::Edit.call(id, params[:cultivar_group], res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('fruit', 'delete')
          res = interactor.delete_cultivar_group(id)
          delete_grid_row(id, notice: res.message)
        end
      end
    end
    r.on 'cultivar_groups' do
      interactor = MasterfilesApp::CultivarInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('fruit', 'new')
        show_partial_or_page(r) { Masterfiles::Fruit::CultivarGroup::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_cultivar_group(params[:cultivar_group])
        if res.success
          flash[:notice] = res.message
          redirect_to_last_grid(r)
        else
          re_show_form(r, res, url: '/masterfiles/fruit/cultivar_groups/new') do
            Masterfiles::Fruit::CultivarGroup::New.call(form_values: params[:cultivar_group],
                                                        form_errors: res.errors,
                                                        remote: fetch?(r))
          end
        end
      end
    end
    # CULTIVARS
    # --------------------------------------------------------------------------
    r.on 'cultivars', Integer do |id|
      interactor = MasterfilesApp::CultivarInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:cultivars, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('fruit', 'edit')
        show_partial { Masterfiles::Fruit::Cultivar::Edit.call(id) }
      end

      # MARKETING VARIETIES
      # --------------------------------------------------------------------------
      r.on 'link_marketing_varieties' do
        r.post do
          interactor = MasterfilesApp::CultivarInteractor.new(current_user, {}, { route_url: request.path }, {})
          res = interactor.link_marketing_varieties(id, multiselect_grid_choices(params))

          if res.success
            flash[:notice] = res.message
          else
            flash[:error] = res.message
          end
          redirect_to_last_grid(r)
        end
      end
      r.on 'marketing_varieties' do
        interactor = MasterfilesApp::CultivarInteractor.new(current_user, {}, { route_url: request.path }, {})
        r.on 'new' do    # NEW
          check_auth!('fruit', 'new')
          show_partial_or_page(r) { Masterfiles::Fruit::MarketingVariety::New.call(id, remote: fetch?(r)) }
        end
        r.post do        # CREATE
          res = interactor.create_marketing_variety(id, params[:marketing_variety])
          if res.success
            flash[:notice] = res.message
            redirect_to_last_grid(r)
          else
            re_show_form(r, res, url: "/masterfiles/fruit/cultivars/#{id}/marketing_varieties/new") do
              Masterfiles::Fruit::MarketingVariety::New.call(id,
                                                             form_values: params[:marketing_variety],
                                                             form_errors: res.errors,
                                                             remote: fetch?(r))
            end
          end
        end
      end
      r.is do
        r.get do       # SHOW
          check_auth!('fruit', 'read')
          show_partial { Masterfiles::Fruit::Cultivar::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_cultivar(id, params[:cultivar]) # Use Interactor - returned instance is "larger" entity (incl. commod code)
          comm_repo = MasterfilesApp::CommodityRepo.new
          if res.success
            commodity_code = comm_repo.find_commodity(res.instance[:commodity_id])&.code
            update_grid_row(id,
                            changes: { commodity_id: res.instance[:commodity_id],
                                       cultivar_group_id: res.instance[:cultivar_group_id],
                                       cultivar_group_code: res.instance[:cultivar_group_code],
                                       cultivar_name: res.instance[:cultivar_name],
                                       code: commodity_code,
                                       description: res.instance[:description] },
                            notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Fruit::Cultivar::Edit.call(id, params[:cultivar], res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('fruit', 'delete')
          res = interactor.delete_cultivar(id)
          delete_grid_row(id, notice: res.message)
        end
      end
    end
    r.on 'cultivars' do
      interactor = MasterfilesApp::CultivarInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('fruit', 'new')
        show_partial_or_page(r) { Masterfiles::Fruit::Cultivar::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_cultivar(params[:cultivar])
        if res.success
          flash[:notice] = res.message
          redirect_to_last_grid(r)
        else
          re_show_form(r, res, url: '/masterfiles/fruit/cultivars/new') do
            Masterfiles::Fruit::Cultivar::New.call(form_values: params[:cultivar],
                                                   form_errors: res.errors,
                                                   remote: fetch?(r))
          end
        end
      end
    end
    r.on 'marketing_varieties', Integer do |id|
      interactor = MasterfilesApp::CultivarInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:marketing_varieties, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('fruit', 'edit')
        show_partial { Masterfiles::Fruit::MarketingVariety::Edit.call(id) }
      end
      r.is do
        r.get do       # SHOW
          check_auth!('fruit', 'read')
          show_partial { Masterfiles::Fruit::MarketingVariety::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_marketing_variety(id, params[:marketing_variety])
          if res.success
            update_grid_row(id,
                            changes: { marketing_variety_code: res.instance[:marketing_variety_code],
                                       description: res.instance[:description] },
                            notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Fruit::MarketingVariety::Edit.call(id, params[:marketing_variety], res.errors) }
          end
        end
      end
    end
    # BASIC PACK CODES
    # --------------------------------------------------------------------------
    r.on 'basic_pack_codes', Integer do |id|
      interactor = MasterfilesApp::BasicPackCodeInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:basic_pack_codes, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('fruit', 'edit')
        show_partial { Masterfiles::Fruit::BasicPackCode::Edit.call(id) }
      end
      r.is do
        r.get do       # SHOW
          check_auth!('fruit', 'read')
          show_partial { Masterfiles::Fruit::BasicPackCode::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_basic_pack_code(id, params[:basic_pack_code])
          if res.success
            update_grid_row(id,
                            changes: { basic_pack_code: res.instance[:basic_pack_code],
                                       description: res.instance[:description],
                                       length_mm: res.instance[:length_mm],
                                       width_mm: res.instance[:width_mm],
                                       height_mm: res.instance[:height_mm] },
                            notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Fruit::BasicPackCode::Edit.call(id, params[:basic_pack_code], res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('fruit', 'delete')
          res = interactor.delete_basic_pack_code(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message)
          end
        end
      end
    end
    r.on 'basic_pack_codes' do
      interactor = MasterfilesApp::BasicPackCodeInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('fruit', 'new')
        show_partial_or_page(r) { Masterfiles::Fruit::BasicPackCode::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_basic_pack_code(params[:basic_pack_code])
        if res.success
          flash[:notice] = res.message
          redirect_to_last_grid(r)
        else
          re_show_form(r, res, url: '/masterfiles/fruit/basic_pack_codes/new') do
            Masterfiles::Fruit::BasicPackCode::New.call(form_values: params[:basic_pack_code],
                                                        form_errors: res.errors,
                                                        remote: fetch?(r))
          end
        end
      end
    end
    # STANDARD PACK CODES
    # --------------------------------------------------------------------------
    r.on 'standard_pack_codes', Integer do |id|
      interactor = MasterfilesApp::StandardPackCodeInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:standard_pack_codes, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('fruit', 'edit')
        show_partial { Masterfiles::Fruit::StandardPackCode::Edit.call(id) }
      end
      r.is do
        r.get do       # SHOW
          check_auth!('fruit', 'read')
          show_partial { Masterfiles::Fruit::StandardPackCode::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_standard_pack_code(id, params[:standard_pack_code])
          if res.success
            update_grid_row(id,
                            changes: { standard_pack_code: res.instance[:standard_pack_code] },
                            notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Fruit::StandardPackCode::Edit.call(id, params[:standard_pack_code], res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('fruit', 'delete')
          res = interactor.delete_standard_pack_code(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message)
          end
        end
      end
    end
    r.on 'standard_pack_codes' do
      interactor = MasterfilesApp::StandardPackCodeInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('fruit', 'new')
        show_partial_or_page(r) { Masterfiles::Fruit::StandardPackCode::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_standard_pack_code(params[:standard_pack_code])
        if res.success
          flash[:notice] = res.message
          redirect_to_last_grid(r)
        else
          re_show_form(r, res, url: '/masterfiles/fruit/standard_pack_codes/new') do
            Masterfiles::Fruit::StandardPackCode::New.call(form_values: params[:standard_pack_code],
                                                           form_errors: res.errors,
                                                           remote: fetch?(r))
          end
        end
      end
    end
    # STD FRUIT SIZE COUNTS
    # --------------------------------------------------------------------------
    r.on 'std_fruit_size_counts', Integer do |id|
      interactor = MasterfilesApp::FruitSizeInteractor.new(current_user, {}, { route_url: request.path }, {})
      # Check for notfound:
      r.on !interactor.exists?(:std_fruit_size_counts, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('fruit', 'edit')
        show_partial { Masterfiles::Fruit::StdFruitSizeCount::Edit.call(id) }
      end
      r.on 'fruit_actual_counts_for_packs' do
        interactor = MasterfilesApp::FruitSizeInteractor.new(current_user, {}, { route_url: request.path }, {})
        r.on 'new' do    # NEW
          check_auth!('fruit', 'new')
          show_partial_or_page(r) { Masterfiles::Fruit::FruitActualCountsForPack::New.call(id, remote: fetch?(r)) }
        end
        r.post do        # CREATE
          res = interactor.create_fruit_actual_counts_for_pack(id, params[:fruit_actual_counts_for_pack])
          if res.success
            flash[:notice] = res.message
            redirect_to_last_grid(r)
          else
            re_show_form(r, res, url: "/masterfiles/fruit/std_fruit_size_counts/#{id}/fruit_actual_counts_for_packs/new") do
              Masterfiles::Fruit::FruitActualCountsForPack::New.call(id,
                                                                     form_values: params[:fruit_actual_counts_for_pack],
                                                                     form_errors: res.errors,
                                                                     remote: fetch?(r))
            end
          end
        end
      end
      r.is do
        r.get do       # SHOW
          check_auth!('fruit', 'read')
          show_partial { Masterfiles::Fruit::StdFruitSizeCount::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_std_fruit_size_count(id, params[:std_fruit_size_count])
          if res.success
            update_grid_row(id,
                            changes: { commodity_id: res.instance[:commodity_id],
                                       size_count_description: res.instance[:size_count_description],
                                       marketing_size_range_mm: res.instance[:marketing_size_range_mm],
                                       marketing_weight_range: res.instance[:marketing_weight_range],
                                       size_count_interval_group: res.instance[:size_count_interval_group],
                                       size_count_value: res.instance[:size_count_value],
                                       minimum_size_mm: res.instance[:minimum_size_mm],
                                       maximum_size_mm: res.instance[:maximum_size_mm],
                                       average_size_mm: res.instance[:average_size_mm],
                                       minimum_weight_gm: res.instance[:minimum_weight_gm],
                                       maximum_weight_gm: res.instance[:maximum_weight_gm],
                                       average_weight_gm: res.instance[:average_weight_gm] },
                            notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Fruit::StdFruitSizeCount::Edit.call(id, params[:std_fruit_size_count], res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('fruit', 'delete')
          res = interactor.delete_std_fruit_size_count(id)
          delete_grid_row(id, notice: res.message)
        end
      end
    end
    r.on 'std_fruit_size_counts' do
      interactor = MasterfilesApp::FruitSizeInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('fruit', 'new')
        show_partial_or_page(r) { Masterfiles::Fruit::StdFruitSizeCount::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_std_fruit_size_count(params[:std_fruit_size_count])
        if res.success
          flash[:notice] = res.message
          redirect_to_last_grid(r)
        else
          re_show_form(r, res, url: '/masterfiles/fruit/std_fruit_size_counts/new') do
            Masterfiles::Fruit::StdFruitSizeCount::New.call(form_values: params[:std_fruit_size_count],
                                                            form_errors: res.errors,
                                                            remote: fetch?(r))
          end
        end
      end
    end
    r.on 'fruit_actual_counts_for_packs', Integer do |id|
      interactor = MasterfilesApp::FruitSizeInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:fruit_actual_counts_for_packs, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('fruit', 'edit')
        show_partial { Masterfiles::Fruit::FruitActualCountsForPack::Edit.call(id) }
      end
      r.on 'fruit_size_references' do
        interactor = MasterfilesApp::FruitSizeInteractor.new(current_user, {}, { route_url: request.path }, {})
        r.on 'new' do    # NEW
          check_auth!('fruit', 'new')
          show_partial_or_page(r) { Masterfiles::Fruit::FruitSizeReference::New.call(id, remote: fetch?(r)) }
        end
        r.post do        # CREATE
          res = interactor.create_fruit_size_reference(id, params[:fruit_size_reference])
          if res.success
            flash[:notice] = res.message
            redirect_to_last_grid(r)
          else
            re_show_form(r, res, url: "/masterfiles/fruit/fruit_actual_counts_for_packs/#{id}/fruit_size_references/new") do
              Masterfiles::Fruit::FruitSizeReference::New.call(id,
                                                               form_values: params[:fruit_size_reference],
                                                               form_errors: res.errors,
                                                               remote: fetch?(r))
            end
          end
        end
      end
      r.is do
        r.get do       # SHOW
          check_auth!('fruit', 'read')
          show_partial { Masterfiles::Fruit::FruitActualCountsForPack::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_fruit_actual_counts_for_pack(id, params[:fruit_actual_counts_for_pack])
          if res.success
            update_grid_row(id,
                            changes: { std_fruit_size_count_id: res.instance[:std_fruit_size_count_id],
                                       basic_pack_code_id: res.instance[:basic_pack_code_id],
                                       standard_pack_code_id: res.instance[:standard_pack_code_id],
                                       actual_count_for_pack: res.instance[:actual_count_for_pack],
                                       size_count_variation: res.instance[:size_count_variation] },
                            notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Fruit::FruitActualCountsForPack::Edit.call(id, params[:fruit_actual_counts_for_pack], res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('fruit', 'delete')
          res = interactor.delete_fruit_actual_counts_for_pack(id)
          delete_grid_row(id, notice: res.message)
        end
      end
    end
    # FRUIT SIZE REFERENCES
    # --------------------------------------------------------------------------
    r.on 'fruit_size_references', Integer do |id|
      interactor = MasterfilesApp::FruitSizeInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:fruit_size_references, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('fruit', 'edit')
        show_partial { Masterfiles::Fruit::FruitSizeReference::Edit.call(id) }
      end
      r.is do
        r.get do       # SHOW
          check_auth!('fruit', 'read')
          show_partial { Masterfiles::Fruit::FruitSizeReference::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_fruit_size_reference(id, params[:fruit_size_reference])
          if res.success
            update_grid_row(id,
                            changes: { fruit_actual_counts_for_pack_id: res.instance[:fruit_actual_counts_for_pack_id],
                                       size_reference: res.instance[:size_reference] },
                            notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Fruit::FruitSizeReference::Edit.call(id, params[:fruit_size_reference], res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('fruit', 'delete')
          res = interactor.delete_fruit_size_reference(id)
          delete_grid_row(id, notice: res.message)
        end
      end
    end

    r.on 'back', Integer do |id|
      r.on 'fruit_actual_counts_for_packs' do
        # NOTE: Working on the principle that your views are allowed access to your repositories
        # Create interactor method to return parent. - return success/failure & not_found if fail...
        repo = MasterfilesApp::FruitSizeRepo.new
        actual_count = repo.find_fruit_actual_counts_for_pack(id)
        handle_not_found(r) unless actual_count
        check_auth!('fruit', 'read')
        parent_id = actual_count.std_fruit_size_count_id
        r.redirect "/list/fruit_actual_counts_for_packs/with_params?key=standard&fruit_actual_counts_for_packs.std_fruit_size_count_id=#{parent_id}"
      end
    end

    # RMT CLASSES
    # --------------------------------------------------------------------------
    r.on 'rmt_classes', Integer do |id|
      interactor = MasterfilesApp::RmtClassInteractor.new(current_user, {}, { route_url: request.path }, {})

      # Check for notfound:
      r.on !interactor.exists?(:rmt_classes, id) do
        handle_not_found(r)
      end

      r.on 'edit' do   # EDIT
        check_auth!('fruit', 'edit')
        interactor.assert_permission!(:edit, id)
        show_partial { Masterfiles::Fruit::RmtClass::Edit.call(id) }
      end

      # r.on 'complete' do
      #   r.get do
      #     check_auth!('fruit', 'edit')
      #     interactor.assert_permission!(:complete, id)
      #     show_partial { Masterfiles::Fruit::RmtClass::Complete.call(id) }
      #   end

      #   r.post do
      #     res = interactor.complete_a_rmt_class(id, params[:rmt_class])
      #     if res.success
      #       flash[:notice] = res.message
      #       redirect_to_last_grid(r)
      #     else
      #       re_show_form(r, res) { Masterfiles::Fruit::RmtClass::Complete.call(id, params[:rmt_class], res.errors) }
      #     end
      #   end
      # end

      # r.on 'approve' do
      #   r.get do
      #     check_auth!('fruit', 'approve')
      #     interactor.assert_permission!(:approve, id)
      #     show_partial { Masterfiles::Fruit::RmtClass::Approve.call(id) }
      #   end

      #   r.post do
      #     res = interactor.approve_or_reject_a_rmt_class(id, params[:rmt_class])
      #     if res.success
      #       flash[:notice] = res.message
      #       redirect_to_last_grid(r)
      #     else
      #       re_show_form(r, res) { Masterfiles::Fruit::RmtClass::Approve.call(id, params[:rmt_class], res.errors) }
      #     end
      #   end
      # end

      # r.on 'reopen' do
      #   r.get do
      #     check_auth!('fruit', 'edit')
      #     interactor.assert_permission!(:reopen, id)
      #     show_partial { Masterfiles::Fruit::RmtClass::Reopen.call(id) }
      #   end

      #   r.post do
      #     res = interactor.reopen_a_rmt_class(id, params[:rmt_class])
      #     if res.success
      #       flash[:notice] = res.message
      #       redirect_to_last_grid(r)
      #     else
      #       re_show_form(r, res) { Masterfiles::Fruit::RmtClass::Reopen.call(id, params[:rmt_class], res.errors) }
      #     end
      #   end
      # end

      r.is do
        r.get do       # SHOW
          check_auth!('fruit', 'read')
          show_partial { Masterfiles::Fruit::RmtClass::Show.call(id) }
        end
        r.patch do     # UPDATE
          res = interactor.update_rmt_class(id, params[:rmt_class])
          if res.success
            update_grid_row(id, changes: { rmt_class_code: res.instance[:rmt_class_code], description: res.instance[:description] },
                                notice: res.message)
          else
            re_show_form(r, res) { Masterfiles::Fruit::RmtClass::Edit.call(id, form_values: params[:rmt_class], form_errors: res.errors) }
          end
        end
        r.delete do    # DELETE
          check_auth!('fruit', 'delete')
          interactor.assert_permission!(:delete, id)
          res = interactor.delete_rmt_class(id)
          if res.success
            delete_grid_row(id, notice: res.message)
          else
            show_json_error(res.message, status: 200)
          end
        end
      end
    end

    r.on 'rmt_classes' do
      interactor = MasterfilesApp::RmtClassInteractor.new(current_user, {}, { route_url: request.path }, {})
      r.on 'new' do    # NEW
        check_auth!('fruit', 'new')
        show_partial_or_page(r) { Masterfiles::Fruit::RmtClass::New.call(remote: fetch?(r)) }
      end
      r.post do        # CREATE
        res = interactor.create_rmt_class(params[:rmt_class])
        if res.success
          row_keys = %i[
            id
            rmt_class_code
            description
          ]
          add_grid_row(attrs: select_attributes(res.instance, row_keys),
                       notice: res.message)
        else
          re_show_form(r, res, url: '/masterfiles/fruit/rmt_classes/new') do
            Masterfiles::Fruit::RmtClass::New.call(form_values: params[:rmt_class],
                                                   form_errors: res.errors,
                                                   remote: fetch?(r))
          end
        end
      end
    end
  end
end

# rubocop:enable Metrics/ClassLength
# rubocop:enable Metrics/BlockLength
