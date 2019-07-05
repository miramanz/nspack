# frozen_string_literal: true

require File.join(File.expand_path('../../../../test', __dir__), 'test_helper')

module ProductionApp
  class TestResourceRepo < MiniTestWithHooks
    def test_for_selects
      assert_respond_to repo, :for_select_resource_types
      assert_respond_to repo, :for_select_resources
    end

    def test_crud_calls
      test_crud_calls_for :resource_types, name: :resource_type, wrapper: ResourceType
      test_crud_calls_for :resources, name: :resource, wrapper: Resource
    end

    private

    def repo
      ResourceRepo.new
    end
  end
end
