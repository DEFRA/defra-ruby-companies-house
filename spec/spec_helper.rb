# frozen_string_literal: true

require "faker"
require "webmock/rspec"
require "pry-byebug"

require "defra_ruby/companies_house"
require "defra_ruby/companies_house/version"
require "defra_ruby/companies_house/configuration"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # The default logger for this gem writes to console. Redirect here to avoid cluttering rspec output.
  original_stderr = $stderr
  original_stdout = $stdout

  config.before(:all) do
    $stderr = File.open(File::NULL, "w")
    $stdout = File.open(File::NULL, "w")
  end

  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end
