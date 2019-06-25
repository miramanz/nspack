# frozen_string_literal: true

module MasterfilesApp
  class Season < Dry::Struct
    attribute :id, Types::Integer
    attribute :season_group_id, Types::Integer
    attribute :commodity_id, Types::Integer
    attribute :season_code, Types::String
    attribute :description, Types::String
    attribute :year, Types::Integer
    attribute :start_date, Types::DateTime
    attribute :end_date, Types::DateTime
    attribute? :active, Types::Bool
  end
end
