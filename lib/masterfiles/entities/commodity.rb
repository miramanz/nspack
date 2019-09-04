# frozen_string_literal: true

module MasterfilesApp
  class Commodity < Dry::Struct
    attribute :id, Types::Integer
    attribute :commodity_group_id, Types::Integer
    attribute :code, Types::String
    attribute :description, Types::String
    attribute :hs_code, Types::String
    attribute :active, Types::Bool
    attribute :commodity_group_code, Types::String
    attribute :requires_standard_counts, Types::Bool
  end
end
