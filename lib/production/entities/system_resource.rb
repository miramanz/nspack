# frozen_string_literal: true

module ProductionApp
  class SystemResource < Dry::Struct
    attribute :id, Types::Integer
    attribute :plant_resource_type_id, Types::Integer
    attribute :system_resource_type_id, Types::Integer
    attribute :system_resource_code, Types::String
    attribute :description, Types::String
    attribute? :active, Types::Bool
  end
end
