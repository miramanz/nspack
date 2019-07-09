# frozen_string_literal: true

module ProductionApp
  class ResourceInteractor < BaseInteractor
    def repo
      @repo ||= ResourceRepo.new
    end

    def resource(id)
      repo.find_resource(id)
    end

    def validate_resource_params(params)
      ResourceSchema.call(params)
    end

    def create_root_resource(params) # rubocop:disable Metrics/AbcSize
      res = validate_resource_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      id = nil
      repo.transaction do
        id = repo.create_root_resource(res)
        log_status('resources', id, 'CREATED')
        log_transaction
      end
      instance = resource(id)
      success_response("Created resource #{instance.resource_code}",
                       instance)
    rescue Sequel::UniqueConstraintViolation
      validation_failed_response(OpenStruct.new(messages: { resource_code: ['This resource already exists'] }))
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def create_resource(parent_id, params) # rubocop:disable Metrics/AbcSize
      res = validate_resource_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      id = nil
      repo.transaction do
        id = repo.create_child_resource(parent_id, res)
        log_status('resources', id, 'CREATED')
        log_transaction
      end
      instance = resource(id)
      success_response("Created resource #{instance.resource_code}",
                       instance)
    rescue Sequel::UniqueConstraintViolation
      validation_failed_response(OpenStruct.new(messages: { resource_code: ['This resource already exists'] }))
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def update_resource(id, params)
      res = validate_resource_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      repo.transaction do
        repo.update_resource(id, res)
        log_transaction
      end
      instance = resource(id)
      success_response("Updated resource #{instance.resource_code}",
                       instance)
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def delete_resource(id)
      name = resource(id).resource_code
      repo.transaction do
        repo.delete_resource(id)
        log_status('resources', id, 'DELETED')
        log_transaction
      end
      success_response("Deleted resource #{name}")
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def assert_permission!(task, id = nil)
      res = TaskPermissionCheck::Resource.call(task, id)
      raise Crossbeams::TaskNotPermittedError, res.message unless res.success
    end
  end
end
