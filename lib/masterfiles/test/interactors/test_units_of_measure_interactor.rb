# frozen_string_literal: true

require File.join(File.expand_path('../../../../test', __dir__), 'test_helper')

module MasterfilesApp
  class TestUnitsOfMeasureInteractor < MiniTestWithHooks
    include PackagingFactory

    def test_repo
      repo = interactor.send(:repo)
      assert repo.is_a?(MasterfilesApp::BOMsRepo)
    end

    def test_units_of_measure
      MasterfilesApp::BOMsRepo.any_instance.stubs(:find_units_of_measure).returns(fake_units_of_measure)
      entity = interactor.send(:units_of_measure, 1)
      assert entity.is_a?(UnitsOfMeasure)
    end

    def test_create_units_of_measure
      attrs = fake_units_of_measure.to_h.reject { |k, _| k == :id }
      res = interactor.create_units_of_measure(attrs)
      assert res.success, "#{res.message} : #{res.errors.inspect}"
      assert_instance_of(UnitsOfMeasure, res.instance)
      assert res.instance.id.nonzero?
    end

    def test_create_units_of_measure_fail
      attrs = fake_units_of_measure(unit_of_measure: nil).to_h.reject { |k, _| k == :id }
      res = interactor.create_units_of_measure(attrs)
      refute res.success, 'should fail validation'
      assert_equal ['must be filled'], res.errors[:unit_of_measure]
    end

    def test_update_units_of_measure
      id = create_units_of_measure
      attrs = interactor.send(:repo).find_hash(:units_of_measure, id).reject { |k, _| k == :id }
      value = attrs[:unit_of_measure]
      attrs[:unit_of_measure] = 'a_change'
      res = interactor.update_units_of_measure(id, attrs)
      assert res.success, "#{res.message} : #{res.errors.inspect}"
      assert_instance_of(UnitsOfMeasure, res.instance)
      assert_equal 'a_change', res.instance.unit_of_measure
      refute_equal value, res.instance.unit_of_measure
    end

    def test_update_units_of_measure_fail
      id = create_units_of_measure
      attrs = interactor.send(:repo).find_hash(:units_of_measure, id).reject { |k, _| %i[id unit_of_measure].include?(k) }
      value = attrs[:description]
      attrs[:description] = 'a_change'
      res = interactor.update_units_of_measure(id, attrs)
      refute res.success, "#{res.message} : #{res.errors.inspect}"
      assert_equal ['is missing'], res.errors[:unit_of_measure]
      after = interactor.send(:repo).find_hash(:units_of_measure, id)
      refute_equal 'a_change', after[:description]
      assert_equal value, after[:description]
    end

    def test_delete_units_of_measure
      id = create_units_of_measure
      assert_count_changed(:units_of_measure, -1) do
        res = interactor.delete_units_of_measure(id)
        assert res.success, res.message
      end
    end

    private

    def units_of_measure_attrs
      {
        id: 1,
        unit_of_measure: Faker::Lorem.unique.word,
        description: 'ABC',
        active: true
      }
    end

    def fake_units_of_measure(overrides = {})
      UnitsOfMeasure.new(units_of_measure_attrs.merge(overrides))
    end

    def interactor
      @interactor ||= UnitsOfMeasureInteractor.new(current_user, {}, {}, {})
    end
  end
end
