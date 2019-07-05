# frozen_string_literal: true

module ProductionApp
  class Resource < Dry::Struct
    attribute :id, Types::Integer
    attribute :resource_type_id, Types::Integer
    attribute :system_resource_id, Types::Integer
    attribute :resource_code, Types::String
    attribute :description, Types::String
    attribute :resource_attributes, Types::Hash
    attribute? :active, Types::Bool
  end
end
