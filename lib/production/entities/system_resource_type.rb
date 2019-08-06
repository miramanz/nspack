# frozen_string_literal: true

module ProductionApp
  class SystemResourceType < Dry::Struct
    attribute :id, Types::Integer
    attribute :system_resource_type_code, Types::String
    attribute :description, Types::String
    attribute :icon, Types::String
    attribute? :active, Types::Bool
  end
end
