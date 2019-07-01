# frozen_string_literal: true

module MasterfilesApp
  class PucInteractor < BaseInteractor

    def repo
      @repo ||= FarmRepo.new
    end

    def validate_puc_params(params)
      PucSchema.call(params)
    end

    def puc(cached = true)
      if cached
        @puc ||= repo.find_puc(@puc_id)
      else
        @puc = repo.find_puc(@puc_id)
      end
    end

    def update_puc(id, params)
      @puc_id = id
      res = validate_puc_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      repo.transaction do
        repo.update_puc(id, res)
      end
      success_response("Updated puc #{puc.puc_code}", puc(false))
    end

    def delete_puc(id)
      @puc_id = id
      name = puc.puc_code
      repo.transaction do
        repo.delete_farms_pucs(@puc_id)
        repo.delete_puc(id)
      end
      success_response("Deleted puc#{name}")
    end

    def assert_permission!(task, id = nil)
      res = TaskPermissionCheck::Puc.call(task, id)
      raise Crossbeams::TaskNotPermittedError, res.message unless res.success
    end

  end
end
