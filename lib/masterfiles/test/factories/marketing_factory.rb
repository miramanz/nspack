# frozen_string_literal: true

module MasterfilesApp
  module MarketingFactory
    def create_mark(opts = {})
      default = {
        mark_code: Faker::Lorem.unique.word,
        description: Faker::Lorem.word,
        active: true,
        created_at: '2010-01-01 12:00',
        updated_at: '2010-01-01 12:00'
      }
      DB[:marks].insert(default.merge(opts))
    end
  end
end
