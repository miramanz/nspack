# frozen_string_literal: true

module MasterfilesApp
  class FarmInteractor < BaseInteractor
    def repo
      @repo ||= FarmRepo.new
    end

    def farm(id)
      repo.find_farm(id)
    end

    def validate_farm_params(params)
      FarmSchema.call(params)
    end

    def puc(cached = true)
      if cached
        @puc ||= repo.find_puc(@puc_id)
      else
        @puc = repo.find_puc(@puc_id)
      end
    end

    def validate_puc_params(params)
      PucSchema.call(params)
    end

    def create_farm(params)
      res = validate_farm_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      id = nil
      repo.transaction do
        id = repo.create_farm(res)
        log_status('farms', id, 'CREATED')
        log_transaction
      end
      instance = farm(id)
      success_response("Created farm #{instance.farm_code}",
                       instance)
    rescue Sequel::UniqueConstraintViolation
      validation_failed_response(OpenStruct.new(messages: { farm_code: ['This farm already exists'] }))
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def update_farm(id, params)
      res = validate_farm_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      repo.transaction do
        repo.update_farm(id, res)
        log_transaction
      end
      instance = farm(id)
      success_response("Updated farm #{instance.farm_code}",
                       instance)
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def delete_farm(id)
      name = farm(id).farm_code
      repo.transaction do
        repo.delete_farm(id)
        log_status('farms', id, 'DELETED')
        log_transaction
      end
      success_response("Deleted farm #{name}")
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def assert_permission!(task, id = nil)
      res = TaskPermissionCheck::Farm.call(task, id)
      raise Crossbeams::TaskNotPermittedError, res.message unless res.success
    end

    def create_puc(id, params)
      res = validate_puc_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      repo.transaction do
        @puc_id = repo.create_puc(res)
        repo.create_farms_pucs(id,@puc_id)
      end
      success_response("Created puc #{puc.puc_code}", puc)
    rescue Sequel::UniqueConstraintViolation
      validation_failed_response(OpenStruct.new(messages: { puc_code: ['This puc already exists'] }))
    end

  end
end
