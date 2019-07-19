# frozen_string_literal: true

module MasterfilesApp
  class Farm < Dry::Struct
    attribute :id, Types::Integer
    attribute :owner_party_role_id, Types::Integer
    attribute :pdn_region_id, Types::Integer
    attribute :farm_group_id, Types::Integer
    attribute :farm_code, Types::String
    attribute :description, Types::String
    attribute :farms_pucs_ids, Types::Array
    attribute? :active, Types::Bool
  end
end
