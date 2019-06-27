# frozen_string_literal: true

require File.join(File.expand_path('../../../../test', __dir__), 'test_helper')

module MasterfilesApp
  class TestPucInteractor < Minitest::Test
    def test_repo
      repo = interactor.repo
      # repo = interactor.send(:repo)
      assert repo.is_a?(MasterfilesApp::FarmRepo)
    end

    private

    def interactor
      @interactor ||= PucInteractor.new(current_user, {}, {}, {})
    end
  end
end
