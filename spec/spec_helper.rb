# frozen_string_literal: true

RSpec.configure do |config|
  config.before { allow($stdout).to receive(:write) }
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.default_formatter = 'doc'
end
