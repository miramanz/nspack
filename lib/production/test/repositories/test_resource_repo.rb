# frozen_string_literal: true

require File.join(File.expand_path('../../../../test', __dir__), 'test_helper')

module ProductionApp
  class TestResourceRepo < MiniTestWithHooks
    def test_for_selects
      assert_respond_to repo, :for_select_plant_resource_types
      assert_respond_to repo, :for_select_plant_resources
    end

    def test_crud_calls
      test_crud_calls_for :plant_resource_types, name: :plant_resource_type, wrapper: PlantResourceType
      test_crud_calls_for :plant_resources, name: :plant_resource, wrapper: PlantResource
    end

    private

    def repo
      ResourceRepo.new
    end
  end
end
