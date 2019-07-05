# frozen_string_literal: true

module ProductionApp
  class ResourceTypeInteractor < BaseInteractor
    def repo
      @repo ||= ResourceRepo.new
    end

    def resource_type(id)
      repo.find_resource_type(id)
    end

    def validate_resource_type_params(params)
      ResourceTypeSchema.call(params)
    end

    def create_resource_type(params) # rubocop:disable Metrics/AbcSize
      res = validate_resource_type_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      id = nil
      repo.transaction do
        id = repo.create_resource_type(res)
        log_status('resource_types', id, 'CREATED')
        log_transaction
      end
      instance = resource_type(id)
      success_response("Created resource type #{instance.resource_type_code}",
                       instance)
    rescue Sequel::UniqueConstraintViolation
      validation_failed_response(OpenStruct.new(messages: { resource_type_code: ['This resource type already exists'] }))
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def update_resource_type(id, params)
      res = validate_resource_type_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      repo.transaction do
        repo.update_resource_type(id, res)
        log_transaction
      end
      instance = resource_type(id)
      success_response("Updated resource type #{instance.resource_type_code}",
                       instance)
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def delete_resource_type(id)
      name = resource_type(id).resource_type_code
      repo.transaction do
        repo.delete_resource_type(id)
        log_status('resource_types', id, 'DELETED')
        log_transaction
      end
      success_response("Deleted resource type #{name}")
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    # def assert_permission!(task, id = nil)
    #   res = TaskPermissionCheck::ResourceType.call(task, id)
    #   raise Crossbeams::TaskNotPermittedError, res.message unless res.success
    # end
  end
end
