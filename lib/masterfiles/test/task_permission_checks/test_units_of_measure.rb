# frozen_string_literal: true

require File.join(File.expand_path('../../../../test', __dir__), 'test_helper')

module MasterfilesApp
  class TestUnitsOfMeasurePermission < Minitest::Test
    include Crossbeams::Responses

    def entity(attrs = {})
      base_attrs = {
        id: 1,
        unit_of_measure: Faker::Lorem.unique.word,
        description: 'ABC',
        active: true
      }
      MasterfilesApp::UnitsOfMeasure.new(base_attrs.merge(attrs))
    end

    def test_create
      res = MasterfilesApp::TaskPermissionCheck::UnitsOfMeasure.call(:create)
      assert res.success, 'Should always be able to create a units_of_measure'
    end

    def test_edit
      MasterfilesApp::BOMsRepo.any_instance.stubs(:find_units_of_measure).returns(entity)
      res = MasterfilesApp::TaskPermissionCheck::UnitsOfMeasure.call(:edit, 1)
      assert res.success, 'Should be able to edit a units_of_measure'
    end

    def test_delete
      MasterfilesApp::BOMsRepo.any_instance.stubs(:find_units_of_measure).returns(entity)
      res = MasterfilesApp::TaskPermissionCheck::UnitsOfMeasure.call(:delete, 1)
      assert res.success, 'Should be able to delete a units_of_measure'
    end
  end
end
