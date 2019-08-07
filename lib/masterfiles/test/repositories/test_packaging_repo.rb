# frozen_string_literal: true

require File.join(File.expand_path('../../../../test', __dir__), 'test_helper')

module MasterfilesApp
  class TestPackagingRepo < MiniTestWithHooks
    def test_for_selects
      assert_respond_to repo, :for_select_pallet_bases
      assert_respond_to repo, :for_select_pallet_stack_types
    end

    def test_crud_calls
      test_crud_calls_for :pallet_bases, name: :pallet_base, wrapper: PalletBase
      test_crud_calls_for :pallet_stack_types, name: :pallet_stack_type, wrapper: PalletStackType
    end

    private

    def repo
      PackagingRepo.new
    end
  end
end
