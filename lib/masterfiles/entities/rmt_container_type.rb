# frozen_string_literal: true

module MasterfilesApp
  class RmtContainerType < Dry::Struct
    attribute :id, Types::Integer
    attribute :container_type_code, Types::String
    attribute :description, Types::String
    attribute? :active, Types::Bool
  end
end
