# frozen_string_literal: true

require File.join(File.expand_path('../../../../test', __dir__), 'test_helper')

module MasterfilesApp
  class TestBomsRepo < MiniTestWithHooks
    def test_for_selects
      assert_respond_to repo, :for_select_pm_types
      assert_respond_to repo, :for_select_pm_subtypes
      assert_respond_to repo, :for_select_pm_products
      assert_respond_to repo, :for_select_pm_boms
      assert_respond_to repo, :for_select_pm_boms_products
    end

    def test_crud_calls
      test_crud_calls_for :pm_types, name: :pm_type, wrapper: PmType
      test_crud_calls_for :pm_subtypes, name: :pm_subtype, wrapper: PmSubtype
      test_crud_calls_for :pm_products, name: :pm_product, wrapper: PmProduct
      test_crud_calls_for :pm_boms, name: :pm_bom, wrapper: PmBom
      test_crud_calls_for :pm_boms_products, name: :pm_boms_product, wrapper: PmBomsProduct
    end

    private

    def repo
      BomsRepo.new
    end
  end
end
