# frozen_string_literal: true

require File.join(File.expand_path('../../../../test', __dir__), 'test_helper')

module MasterfilesApp
  class TestFruitRepo < MiniTestWithHooks
    def test_for_selects
      assert_respond_to repo, :for_select_rmt_classes
      assert_respond_to repo, :for_select_grades
    end

    def test_crud_calls
      test_crud_calls_for :rmt_classes, name: :rmt_class, wrapper: RmtClass
      test_crud_calls_for :grades, name: :grade, wrapper: Grade
    end

    private

    def repo
      FruitRepo.new
    end
  end
end
