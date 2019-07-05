# frozen_string_literal: true

module ProductionApp
  class ResourceType < Dry::Struct
    attribute :id, Types::Integer
    attribute :resource_type_code, Types::String
    attribute :description, Types::String
    attribute :attribute_rules, Types::Hash
    attribute :behaviour_rules, Types::Hash
    attribute? :active, Types::Bool
  end
end
