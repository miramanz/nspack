# frozen_string_literal: true

module MasterfilesApp
  class UnitsOfMeasure < Dry::Struct
    attribute :id, Types::Integer
    attribute :unit_of_measure, Types::String
    attribute :description, Types::String
    attribute? :active, Types::Bool
  end
end
