# frozen_string_literal: true

module Helper
  def help
    :available
  end

  def capture_stdout
    begin
      $stdout = StringIO.new
      yield
      stdout = $stdout.string.split("\n").map(&:chomp)
      puts stdout
    ensure
      $stdout = STDOUT
    end
    stdout
  end
end

RSpec.configure do |config|
  config.include Helper

  # config.before { allow($stdout).to receive(:write) }
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.default_formatter = 'doc'
end
