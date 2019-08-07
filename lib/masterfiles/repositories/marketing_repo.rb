# frozen_string_literal: true

module MasterfilesApp
  class MarketingRepo < BaseRepo
    build_for_select :marks,
                     label: :mark_code,
                     value: :id,
                     order_by: :mark_code
    build_inactive_select :marks,
                          label: :mark_code,
                          value: :id,
                          order_by: :mark_code

    crud_calls_for :marks, name: :mark, wrapper: Mark
  end
end
