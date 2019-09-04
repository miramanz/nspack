# frozen_string_literal: true

module Masterfiles
  module Packaging
    module PalletFormat
      class Show
        def self.call(id)
          ui_rule = UiRules::Compiler.new(:pallet_format, :show, id: id)
          rules   = ui_rule.compile

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object ui_rule.form_object
            page.form do |form|
              # form.caption 'Pallet Format'
              form.view_only!
              form.add_field :description
              form.add_field :pallet_base_id
              form.add_field :pallet_stack_type_id
              form.add_field :active
            end
          end

          layout
        end
      end
    end
  end
end
