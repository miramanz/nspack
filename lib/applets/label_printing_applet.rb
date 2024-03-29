# frozen_string_literal: true

root_dir = File.expand_path('..', __dir__)
Dir["#{root_dir}/label_printing/services/*.rb"].each { |f| require f }

module LabelPrintingApp
end
