# frozen_string_literal: true

module ProductionApp
  class PlantResource < Dry::Struct
    attribute :id, Types::Integer
    attribute :plant_resource_type_id, Types::Integer
    attribute :system_resource_id, Types::Integer
    attribute :plant_resource_code, Types::String
    attribute :description, Types::String
    attribute? :active, Types::Bool
  end
  class PlantResourceWithSystem < Dry::Struct
    attribute :id, Types::Integer
    attribute :plant_resource_type_id, Types::Integer
    attribute :system_resource_id, Types::Integer
    attribute :plant_resource_code, Types::String
    attribute :description, Types::String
    attribute :system_resource_code, Types::String
    attribute? :active, Types::Bool
  end
end
