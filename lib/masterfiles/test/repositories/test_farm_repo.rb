# frozen_string_literal: true

require File.join(File.expand_path('../../../../test', __dir__), 'test_helper')

module MasterfilesApp
  class TestFarmRepo < MiniTestWithHooks
    def test_for_selects
      assert_respond_to repo, :for_select_production_regions
    end

    def test_crud_calls
      test_crud_calls_for :production_regions, name: :production_region, wrapper: ProductionRegion
    end

    private

    def repo
      FarmRepo.new
    end
  end
end
