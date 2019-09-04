# frozen_string_literal: true

module MasterfilesApp
  class Grade < Dry::Struct
    attribute :id, Types::Integer
    attribute :grade_code, Types::String
    attribute :description, Types::String
    attribute? :active, Types::Bool
  end
end
