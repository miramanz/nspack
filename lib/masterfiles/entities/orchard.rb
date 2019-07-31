# frozen_string_literal: true

module MasterfilesApp
  class Orchard < Dry::Struct
    attribute :id, Types::Integer
    attribute :farm_id, Types::Integer
    attribute :puc_id, Types::Integer
    attribute :orchard_code, Types::String
    attribute :description, Types::String
    attribute :cultivar_ids, Types::Array
    attribute :puc_code, Types::String
    attribute :cultivar_names, Types::String
    attribute? :active, Types::Bool
  end
end
