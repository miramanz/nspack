# frozen_string_literal: true

module MasterfilesApp
  class Orchard < Dry::Struct
    attribute :id, Types::Integer
    attribute :farm_id, Types::Integer
    attribute :puc_id, Types::Integer
    attribute :orchard_code, Types::String
    attribute :description, Types::String
    attribute :cultivars, Types::Array
    attribute? :active, Types::Bool
  end
end
