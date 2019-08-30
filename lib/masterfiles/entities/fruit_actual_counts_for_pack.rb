# frozen_string_literal: true

module MasterfilesApp
  class FruitActualCountsForPack < Dry::Struct
    attribute :id, Types::Integer
    attribute :std_fruit_size_count_id, Types::Integer
    attribute :basic_pack_code_id, Types::Integer
    attribute :actual_count_for_pack, Types::Integer
    attribute :standard_pack_code_ids, Types::Array
    attribute :size_reference_ids, Types::Array
    attribute :std_fruit_size_count, Types::String
    attribute :basic_pack_code, Types::String
    attribute :standard_pack_codes, Types::String
    attribute :size_references, Types::String
    attribute? :active, Types::Bool
  end
end
