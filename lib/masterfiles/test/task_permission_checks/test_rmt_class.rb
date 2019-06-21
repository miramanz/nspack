# frozen_string_literal: true

require File.join(File.expand_path('../../../../test', __dir__), 'test_helper')

module MasterfilesApp
  class TestRmtClassPermission < Minitest::Test
    include Crossbeams::Responses

    def entity(attrs = {})
      base_attrs = {
        id: 1,
        rmt_class_code: 'ABC',
        description: 'ABC',
        active: true
      }
      MasterfilesApp::RmtClass.new(base_attrs.merge(attrs))
    end

    def test_create
      res = MasterfilesApp::TaskPermissionCheck::RmtClass.call(:create)
      assert res.success, 'Should always be able to create a rmt_class'
    end

    def test_edit
      MasterfilesApp::FruitRepo.any_instance.stubs(:find_rmt_class).returns(entity)
      res = MasterfilesApp::TaskPermissionCheck::RmtClass.call(:edit, 1)
      assert res.success, 'Should be able to edit a rmt_class'

      # MasterfilesApp::FruitRepo.any_instance.stubs(:find_rmt_class).returns(entity(completed: true))
      # res = MasterfilesApp::TaskPermissionCheck::RmtClass.call(:edit, 1)
      # refute res.success, 'Should not be able to edit a completed rmt_class'
    end

    def test_delete
      MasterfilesApp::FruitRepo.any_instance.stubs(:find_rmt_class).returns(entity)
      res = MasterfilesApp::TaskPermissionCheck::RmtClass.call(:delete, 1)
      assert res.success, 'Should be able to delete a rmt_class'

      # MasterfilesApp::FruitRepo.any_instance.stubs(:find_rmt_class).returns(entity(completed: true))
      # res = MasterfilesApp::TaskPermissionCheck::RmtClass.call(:delete, 1)
      # refute res.success, 'Should not be able to delete a completed rmt_class'
    end

    # def test_complete
    #   MasterfilesApp::FruitRepo.any_instance.stubs(:find_rmt_class).returns(entity)
    #   res = MasterfilesApp::TaskPermissionCheck::RmtClass.call(:complete, 1)
    #   assert res.success, 'Should be able to complete a rmt_class'

    #   MasterfilesApp::FruitRepo.any_instance.stubs(:find_rmt_class).returns(entity(completed: true))
    #   res = MasterfilesApp::TaskPermissionCheck::RmtClass.call(:complete, 1)
    #   refute res.success, 'Should not be able to complete an already completed rmt_class'
    # end

    # def test_approve
    #   MasterfilesApp::FruitRepo.any_instance.stubs(:find_rmt_class).returns(entity(completed: true, approved: false))
    #   res = MasterfilesApp::TaskPermissionCheck::RmtClass.call(:approve, 1)
    #   assert res.success, 'Should be able to approve a completed rmt_class'

    #   MasterfilesApp::FruitRepo.any_instance.stubs(:find_rmt_class).returns(entity)
    #   res = MasterfilesApp::TaskPermissionCheck::RmtClass.call(:approve, 1)
    #   refute res.success, 'Should not be able to approve a non-completed rmt_class'

    #   MasterfilesApp::FruitRepo.any_instance.stubs(:find_rmt_class).returns(entity(completed: true, approved: true))
    #   res = MasterfilesApp::TaskPermissionCheck::RmtClass.call(:approve, 1)
    #   refute res.success, 'Should not be able to approve an already approved rmt_class'
    # end

    # def test_reopen
    #   MasterfilesApp::FruitRepo.any_instance.stubs(:find_rmt_class).returns(entity)
    #   res = MasterfilesApp::TaskPermissionCheck::RmtClass.call(:reopen, 1)
    #   refute res.success, 'Should not be able to reopen a rmt_class that has not been approved'

    #   MasterfilesApp::FruitRepo.any_instance.stubs(:find_rmt_class).returns(entity(completed: true, approved: true))
    #   res = MasterfilesApp::TaskPermissionCheck::RmtClass.call(:reopen, 1)
    #   assert res.success, 'Should be able to reopen an approved rmt_class'
    # end
  end
end
