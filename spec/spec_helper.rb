# frozen_string_literal: true

RSpec.configure do |config|
  config.before { allow($stdout).to receive(:write) }

  config.default_formatter = 'doc'
end
