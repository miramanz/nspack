# frozen_string_literal: true

require File.join(File.expand_path('../../../../test', __dir__), 'test_helper')

module MasterfilesApp
  class TestSeasonGroupPermission < Minitest::Test
    include Crossbeams::Responses

    def entity(attrs = {})
      base_attrs = {
        id: 1,
        season_group_code: 'ABC',
        description: 'ABC',
        season_group_year: 1,
        active: true
      }
      MasterfilesApp::SeasonGroup.new(base_attrs.merge(attrs))
    end

    def test_create
      res = MasterfilesApp::TaskPermissionCheck::SeasonGroup.call(:create)
      assert res.success, 'Should always be able to create a season_group'
    end

    def test_edit
      MasterfilesApp::CalendarRepo.any_instance.stubs(:find_season_group).returns(entity)
      res = MasterfilesApp::TaskPermissionCheck::SeasonGroup.call(:edit, 1)
      assert res.success, 'Should be able to edit a season_group'

      MasterfilesApp::CalendarRepo.any_instance.stubs(:find_season_group).returns(entity(completed: true))
      res = MasterfilesApp::TaskPermissionCheck::SeasonGroup.call(:edit, 1)
      refute res.success, 'Should not be able to edit a completed season_group'
    end

    def test_delete
      MasterfilesApp::CalendarRepo.any_instance.stubs(:find_season_group).returns(entity)
      res = MasterfilesApp::TaskPermissionCheck::SeasonGroup.call(:delete, 1)
      assert res.success, 'Should be able to delete a season_group'

      MasterfilesApp::CalendarRepo.any_instance.stubs(:find_season_group).returns(entity(completed: true))
      res = MasterfilesApp::TaskPermissionCheck::SeasonGroup.call(:delete, 1)
      refute res.success, 'Should not be able to delete a completed season_group'
    end

    # def test_complete
    #   MasterfilesApp::CalendarRepo.any_instance.stubs(:find_season_group).returns(entity)
    #   res = MasterfilesApp::TaskPermissionCheck::SeasonGroup.call(:complete, 1)
    #   assert res.success, 'Should be able to complete a season_group'

    #   MasterfilesApp::CalendarRepo.any_instance.stubs(:find_season_group).returns(entity(completed: true))
    #   res = MasterfilesApp::TaskPermissionCheck::SeasonGroup.call(:complete, 1)
    #   refute res.success, 'Should not be able to complete an already completed season_group'
    # end

    # def test_approve
    #   MasterfilesApp::CalendarRepo.any_instance.stubs(:find_season_group).returns(entity(completed: true, approved: false))
    #   res = MasterfilesApp::TaskPermissionCheck::SeasonGroup.call(:approve, 1)
    #   assert res.success, 'Should be able to approve a completed season_group'

    #   MasterfilesApp::CalendarRepo.any_instance.stubs(:find_season_group).returns(entity)
    #   res = MasterfilesApp::TaskPermissionCheck::SeasonGroup.call(:approve, 1)
    #   refute res.success, 'Should not be able to approve a non-completed season_group'

    #   MasterfilesApp::CalendarRepo.any_instance.stubs(:find_season_group).returns(entity(completed: true, approved: true))
    #   res = MasterfilesApp::TaskPermissionCheck::SeasonGroup.call(:approve, 1)
    #   refute res.success, 'Should not be able to approve an already approved season_group'
    # end

    # def test_reopen
    #   MasterfilesApp::CalendarRepo.any_instance.stubs(:find_season_group).returns(entity)
    #   res = MasterfilesApp::TaskPermissionCheck::SeasonGroup.call(:reopen, 1)
    #   refute res.success, 'Should not be able to reopen a season_group that has not been approved'

    #   MasterfilesApp::CalendarRepo.any_instance.stubs(:find_season_group).returns(entity(completed: true, approved: true))
    #   res = MasterfilesApp::TaskPermissionCheck::SeasonGroup.call(:reopen, 1)
    #   assert res.success, 'Should be able to reopen an approved season_group'
    # end
  end
end
