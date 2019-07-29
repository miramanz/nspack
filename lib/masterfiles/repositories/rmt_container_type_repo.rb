# frozen_string_literal: true

module MasterfilesApp
  class RmtContainerTypeRepo < BaseRepo
    build_for_select :rmt_container_types,
                     label: :container_type_code,
                     value: :id,
                     order_by: :container_type_code
    build_inactive_select :rmt_container_types,
                          label: :container_type_code,
                          value: :id,
                          order_by: :container_type_code

    crud_calls_for :rmt_container_types, name: :rmt_container_type, wrapper: RmtContainerType
  end
end
