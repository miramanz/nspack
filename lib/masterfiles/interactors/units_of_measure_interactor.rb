# frozen_string_literal: true

module MasterfilesApp
  class UnitsOfMeasureInteractor < BaseInteractor
    def create_units_of_measure(params) # rubocop:disable Metrics/AbcSize
      res = validate_units_of_measure_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      id = nil
      repo.transaction do
        id = repo.create_units_of_measure(res)
        log_status('units_of_measure', id, 'CREATED')
        log_transaction
      end
      instance = units_of_measure(id)
      success_response("Created units of measure #{instance.unit_of_measure}",
                       instance)
    rescue Sequel::UniqueConstraintViolation
      validation_failed_response(OpenStruct.new(messages: { unit_of_measure: ['This units of measure already exists'] }))
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def update_units_of_measure(id, params)
      res = validate_units_of_measure_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      repo.transaction do
        repo.update_units_of_measure(id, res)
        log_transaction
      end
      instance = units_of_measure(id)
      success_response("Updated units of measure #{instance.unit_of_measure}",
                       instance)
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def delete_units_of_measure(id)
      name = units_of_measure(id).unit_of_measure
      repo.transaction do
        repo.delete_units_of_measure(id)
        log_status('units_of_measure', id, 'DELETED')
        log_transaction
      end
      success_response("Deleted units of measure #{name}")
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def assert_permission!(task, id = nil)
      res = TaskPermissionCheck::UnitsOfMeasure.call(task, id)
      raise Crossbeams::TaskNotPermittedError, res.message unless res.success
    end

    private

    def repo
      @repo ||= BOMsRepo.new
    end

    def units_of_measure(id)
      repo.find_units_of_measure(id)
    end

    def validate_units_of_measure_params(params)
      UnitsOfMeasureSchema.call(params)
    end
  end
end
