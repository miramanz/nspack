# frozen_string_literal: true

module Crossbeams
  module Config
    # Store rules for Resource types like how to build resource trees and associations.
    class ResourceDefinitions
      SITE = 'SITE'
      PACKHOUSE = 'PACKHOUSE'
      LINE = 'LINE'
      DROP = 'DROP'
      DROP_STATION = 'DROP_STATiON'
      DROP_TABLE = 'DROP_TABLE'
      ROBOT = 'ROBOT'
      FORKLIFT = 'FORKLIFT'

      ROOT_PLANT_RESOURCE_TYPES = [SITE, FORKLIFT].freeze

      PLANT_RESOURCE_RULES = {
        SITE => { description: 'Site', allowed_children: [PACKHOUSE] },
        PACKHOUSE => { description: 'Packhouse', allowed_children: [LINE, ROBOT] },
        LINE => { description: 'Line', allowed_children: [DROP, DROP_STATION, DROP, ROBOT] },
        DROP => { description: 'Drop', allowed_children: [DROP_STATION, DROP, ROBOT] },
        DROP_STATION => { description: 'Drop station', allowed_children: [DROP, ROBOT] },
        DROP => { description: 'Drop', allowed_children: [ROBOT] },
        ROBOT => { description: 'Robot', allowed_children: [], create_with_system_resource: 'MODULE' }, # ... module
        FORKLIFT => { description: 'Forklift', allowed_children: [ROBOT] }
      }.freeze

      def self.refresh_resource_types
        cnt = 0
        repo = BaseRepo.new
        PLANT_RESOURCE_RULES.each_key do |key|
          next if repo.exists?(:resource_types, resource_type_code: key)

          repo.create(:resource_types, resource_type_code: key, description: PLANT_RESOURCE_RULES[key][:description])
          cnt += 1
        end

        if cnt.zero?
          'There are no new resource types to add'
        else
          desc = cnt == 1 ? 'type was' : 'types were'
          "#{cnt} new resource #{desc} added"
        end
      end

      def self.can_have_children?(resource_type_code)
        !PLANT_RESOURCE_RULES[resource_type_code][:allowed_children].empty?
      end
    end
  end
end
