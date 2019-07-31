# frozen_string_literal: true

module MasterfilesApp
  class CalendarRepo < BaseRepo
    build_for_select :season_groups,
                     label: :season_group_code,
                     value: :id,
                     order_by: :season_group_code
    build_inactive_select :season_groups,
                          label: :season_group_code,
                          value: :id,
                          order_by: :season_group_code

    build_for_select :seasons,
                     label: :season_code,
                     value: :id,
                     order_by: :season_code
    build_inactive_select :seasons,
                          label: :season_code,
                          value: :id,
                          order_by: :season_code

    crud_calls_for :season_groups, name: :season_group, wrapper: SeasonGroup
    crud_calls_for :seasons, name: :season, wrapper: Season
  end
end
