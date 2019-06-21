# frozen_string_literal: true

require File.join(File.expand_path('../../../../test', __dir__), 'test_helper')

module MasterfilesApp
  class TestCalendarRepo < MiniTestWithHooks
    def test_for_selects
      assert_respond_to repo, :for_select_season_groups
    end

    def test_crud_calls
      test_crud_calls_for :season_groups, name: :season_group, wrapper: SeasonGroup
    end

    private

    def repo
      CalendarRepo.new
    end
  end
end
