# frozen_string_literal: true

module MasterfilesApp
  class SeasonInteractor < BaseInteractor
    def repo
      @repo ||= CalendarRepo.new
    end

    def season(id)
      repo.find_season(id)
    end

    def validate_season_params(params)
      SeasonSchema.call(params)
    end

    def create_season(params) # rubocop:disable Metrics/AbcSize
      res = validate_season_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      id = nil
      repo.transaction do
        id = repo.create_season(res)
        log_status('seasons', id, 'CREATED')
        log_transaction
      end
      instance = season(id)
      success_response("Created season #{instance.season_code}",
                       instance)
    rescue Sequel::UniqueConstraintViolation
      validation_failed_response(OpenStruct.new(messages: { season_code: ['This season already exists'] }))
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def update_season(id, params)
      res = validate_season_params(params)
      return validation_failed_response(res) unless res.messages.empty?

      repo.transaction do
        repo.update_season(id, res)
        log_transaction
      end
      instance = season(id)
      success_response("Updated season #{instance.season_code}",
                       instance)
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def delete_season(id)
      name = season(id).season_code
      repo.transaction do
        repo.delete_season(id)
        log_status('seasons', id, 'DELETED')
        log_transaction
      end
      success_response("Deleted season #{name}")
    rescue Crossbeams::InfoError => e
      failed_response(e.message)
    end

    def assert_permission!(task, id = nil)
      res = TaskPermissionCheck::Season.call(task, id)
      raise Crossbeams::TaskNotPermittedError, res.message unless res.success
    end
  end
end
