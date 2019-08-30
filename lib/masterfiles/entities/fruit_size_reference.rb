# frozen_string_literal: true

module MasterfilesApp
  class FruitSizeReference < Dry::Struct
    attribute :id, Types::Integer
    attribute :size_reference, Types::String
    attribute? :active, Types::Bool
  end
end
