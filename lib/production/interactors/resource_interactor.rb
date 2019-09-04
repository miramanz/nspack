# frozen_string_literal: true

module ProductionApp
  class ResourceInteractor < BaseInteractor
    def create_root_plant_resource(params) # rubocop:disable Metrics/AbcSize
      res = validate_plant_resource_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      id = nil
      repo.transaction do
        id = repo.create_root_plant_resource(res)
        log_status('plant_resources', id, 'CREATED')
        log_transaction
      end
      instance = plant_resource(id)
      success_response("Created plant resource #{instance.plant_resource_code}",
                       instance)
    rescue Sequel::UniqueConstraintViolation
      validation_failed_response(OpenStruct.new(messages: { plant_resource_code: ['This plant resource already exists'] }))
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def create_plant_resource(parent_id, params) # rubocop:disable Metrics/AbcSize
      res = validate_plant_resource_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      id = nil
      repo.transaction do
        id = repo.create_child_plant_resource(parent_id, res)
        log_status('plant_resources', id, 'CREATED')
        log_transaction
      end
      instance = plant_resource(id)
      success_response("Created plant resource #{instance.plant_resource_code}",
                       instance)
    rescue Sequel::UniqueConstraintViolation
      validation_failed_response(OpenStruct.new(messages: { plant_resource_code: ['This plant resource already exists'] }))
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def update_plant_resource(id, params)
      res = validate_plant_resource_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      repo.transaction do
        repo.update_plant_resource(id, res)
        log_transaction
      end
      instance = plant_resource(id)
      success_response("Updated plant resource #{instance.plant_resource_code}",
                       instance)
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def delete_plant_resource(id)
      name = plant_resource(id).plant_resource_code
      repo.transaction do
        repo.delete_plant_resource(id)
        log_status('plant_resources', id, 'DELETED')
        log_transaction
      end
      success_response("Deleted plant resource #{name}")
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def assert_permission!(task, id = nil)
      res = TaskPermissionCheck::PlantResource.call(task, id)
      raise Crossbeams::TaskNotPermittedError, res.message unless res.success
    end

    private

    def repo
      @repo ||= ResourceRepo.new
    end

    def plant_resource(id)
      repo.find_plant_resource(id)
    end

    def validate_plant_resource_params(params)
      PlantResourceSchema.call(params)
    end
  end
end
