# frozen_string_literal: true

module ProductionApp
  module TaskPermissionCheck
    class PlantResource < BaseService
      attr_reader :task, :entity
      def initialize(task, plant_resource_id = nil)
        @task = task
        @repo = ResourceRepo.new
        @id = plant_resource_id
        @entity = @id ? @repo.find_plant_resource(@id) : nil
      end

      CHECKS = {
        create: :create_check,
        edit: :edit_check,
        delete: :delete_check,
        add_child: :add_child_check
        # approve: :approve_check,
        # reopen: :reopen_check
      }.freeze

      def call
        return failed_response 'Record not found' unless @entity || task == :create

        check = CHECKS[task]
        raise ArgumentError, "Task \"#{task}\" is unknown for #{self.class}" if check.nil?

        send(check)
      end

      private

      def create_check
        all_ok
      end

      def edit_check
        # return failed_response 'Resource has been completed' if completed?

        all_ok
      end

      def delete_check
        # return failed_response 'Resource has been completed' if completed?

        all_ok
      end

      def add_child_check
        if Crossbeams::Config::ResourceDefinitions.can_have_children?(@repo.plant_resource_type_code_for(@id))
          all_ok
        else
          failed_response 'This plant resource cannot have sub-resources'
        end
      end

      # def complete_check
      #   return failed_response 'Resource has already been completed' if completed?

      #   all_ok
      # end

      # def approve_check
      #   return failed_response 'Resource has not been completed' unless completed?
      #   return failed_response 'Resource has already been approved' if approved?

      #   all_ok
      # end

      # def reopen_check
      #   return failed_response 'Resource has not been approved' unless approved?

      #   all_ok
      # end

      # def completed?
      #   @entity.completed
      # end

      # def approved?
      #   @entity.approved
      # end
    end
  end
end
