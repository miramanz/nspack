# frozen_string_literal: true

module Masterfiles
  module Packaging
    module PalletStackType
      class Show
        def self.call(id)
          ui_rule = UiRules::Compiler.new(:pallet_stack_type, :show, id: id)
          rules   = ui_rule.compile

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object ui_rule.form_object
            page.form do |form|
              # form.caption 'Pallet Stack Type'
              form.view_only!
              form.add_field :stack_type_code
              form.add_field :description
              form.add_field :stack_height
              form.add_field :active
              form.add_field :pallet_formats
            end
          end

          layout
        end
      end
    end
  end
end
