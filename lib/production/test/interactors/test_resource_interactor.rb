# frozen_string_literal: true

require File.join(File.expand_path('../../../../test', __dir__), 'test_helper')

module ProductionApp
  class TestResourceInteractor < Minitest::Test
    def test_repo
      repo = interactor.send(:repo)
      assert repo.is_a?(ProductionApp::ResourceRepo)
    end

    private

    def interactor
      @interactor ||= ResourceInteractor.new(current_user, {}, {}, {})
    end
  end
end
