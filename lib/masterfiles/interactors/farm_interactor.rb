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

    def create_farm(params)
      res = validate_farm_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      id = nil
      repo.transaction do
        response = repo.create_farm(res)
        id = response[:id]
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

      attrs = res.to_h
      attrs.delete(:puc_id)

      repo.transaction do
        repo.update_farm(id, attrs)
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

    def selected_farm_groups(owner_party_role_id)
      repo.for_select_farm_groups(where: { owner_party_role_id: owner_party_role_id })
    end

    def associate_farms_pucs(id, farms_pucs_ids)
      return validation_failed_response(OpenStruct.new(messages: { farms_pucs_ids: ['You did not choose a puc'] })) if farms_pucs_ids.empty?

      repo.transaction do
        repo.associate_farms_pucs(id, farms_pucs_ids)
      end
      success_response('Farm => Puc associated successfully')
    end

  end
end
