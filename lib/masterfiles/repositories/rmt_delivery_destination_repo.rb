# frozen_string_literal: true

module MasterfilesApp
  class RmtDeliveryDestinationRepo < BaseRepo
    build_for_select :rmt_delivery_destinations,
                     label: :delivery_destination_code,
                     value: :id,
                     order_by: :delivery_destination_code
    build_inactive_select :rmt_delivery_destinations,
                          label: :delivery_destination_code,
                          value: :id,
                          order_by: :delivery_destination_code

    crud_calls_for :rmt_delivery_destinations, name: :rmt_delivery_destination, wrapper: RmtDeliveryDestination
  end
end
