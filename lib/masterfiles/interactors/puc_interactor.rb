# frozen_string_literal: true

module MasterfilesApp
  class PucInteractor < BaseInteractor

    def assert_permission!(task, id = nil)
      res = TaskPermissionCheck::Puc.call(task, id)
      raise Crossbeams::TaskNotPermittedError, res.message unless res.success
    end
  end
end
