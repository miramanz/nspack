# frozen_string_literal: true

module Masterfiles
  module Farms
    module Orchard
      class New
        def self.call(farm_id, form_values: nil, form_errors: nil, remote: true) # rubocop:disable Metrics/AbcSize
          ui_rule = UiRules::Compiler.new(:orchard, :new, farm_id: farm_id, form_values: form_values)
          rules   = ui_rule.compile

          layout = Crossbeams::Layout::Page.build(rules) do |page|
            page.form_object ui_rule.form_object
            page.form_values form_values
            page.form_errors form_errors
            page.form do |form|
              form.caption 'New Orchard'
              form.action "/masterfiles/farms/farms/#{farm_id}/orchards/new"
              form.remote! if remote
              form.add_field :farm
              form.add_field :farm_id
              form.add_field :puc_id
              form.add_field :orchard_code
              form.add_field :description
              form.add_field :cultivar_ids
            end
          end

          layout
        end
      end
    end
  end
end
