# frozen_string_literal: true

module MasterfilesApp
  class FruitRepo < BaseRepo
    build_for_select :rmt_classes,
                     label: :rmt_class_code,
                     value: :id,
                     order_by: :rmt_class_code
    build_inactive_select :rmt_classes,
                          label: :rmt_class_code,
                          value: :id,
                          order_by: :rmt_class_code

    crud_calls_for :rmt_classes, name: :rmt_class, wrapper: RmtClass
  end
end
