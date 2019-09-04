# frozen_string_literal: true

require File.join(File.expand_path('../../../../test', __dir__), 'test_helper')

module MasterfilesApp
  class TestPmProductInteractor < MiniTestWithHooks
    include PackagingFactory

    def test_repo
      repo = interactor.send(:repo)
      assert repo.is_a?(MasterfilesApp::BomsRepo)
    end

    def test_pm_product
      MasterfilesApp::BomsRepo.any_instance.stubs(:find_pm_product).returns(fake_pm_product)
      entity = interactor.send(:pm_product, 1)
      assert entity.is_a?(PmProduct)
    end

    def test_create_pm_product
      attrs = fake_pm_product.to_h.reject { |k, _| k == :id }
      res = interactor.create_pm_product(attrs)
      assert res.success, "#{res.message} : #{res.errors.inspect}"
      assert_instance_of(PmProduct, res.instance)
      assert res.instance.id.nonzero?
    end

    def test_create_pm_product_fail
      attrs = fake_pm_product(product_code: nil).to_h.reject { |k, _| k == :id }
      res = interactor.create_pm_product(attrs)
      refute res.success, 'should fail validation'
      assert_equal ['must be filled'], res.errors[:product_code]
    end

    def test_update_pm_product
      id = create_pm_product
      attrs = interactor.send(:repo).find_pm_product(id)
      attrs = attrs.to_h
      value = attrs[:product_code]
      attrs[:product_code] = 'a_change'
      res = interactor.update_pm_product(id, attrs)
      assert res.success, "#{res.message} : #{res.errors.inspect}"
      assert_instance_of(PmProduct, res.instance)
      assert_equal 'a_change', res.instance.product_code
      refute_equal value, res.instance.product_code
    end

    def test_update_pm_product_fail
      id = create_pm_product
      attrs = interactor.send(:repo).find_pm_product(id)
      attrs = attrs.to_h
      attrs.delete(:product_code)
      value = attrs[:erp_code]
      attrs[:erp_code] = 'a_change'
      res = interactor.update_pm_product(id, attrs)
      refute res.success, "#{res.message} : #{res.errors.inspect}"
      assert_equal ['is missing'], res.errors[:product_code]
      after = interactor.send(:repo).find_pm_product(id)
      after = after.to_h
      refute_equal 'a_change', after[:erp_code]
      assert_equal value, after[:erp_code]
    end

    def test_delete_pm_product
      id = create_pm_product
      assert_count_changed(:pm_products, -1) do
        res = interactor.delete_pm_product(id)
        assert res.success, res.message
      end
    end

    private

    def pm_product_attrs
      pm_subtype_id = create_pm_subtype

      {
        id: 1,
        pm_subtype_id: pm_subtype_id,
        erp_code: Faker::Lorem.unique.word,
        product_code: 'ABC',
        description: 'ABC',
        active: true,
        subtype_code: 'ABC'
      }
    end

    def fake_pm_product(overrides = {})
      PmProduct.new(pm_product_attrs.merge(overrides))
    end

    def interactor
      @interactor ||= PmProductInteractor.new(current_user, {}, {}, {})
    end
  end
end
