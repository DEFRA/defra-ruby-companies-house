# frozen_string_literal: true

require "bundler/setup"

# Require and run our simplecov initializer as the very first thing we do.
# This is as per its docs https://github.com/colszowka/simplecov#getting-started
require "./spec/support/simplecov"

require "faker"
require "webmock/rspec"
require "pry-byebug"

require "defra_ruby/companies_house"
require "defra_ruby/companies_house/version"
require "defra_ruby/companies_house/configuration"

# We make an exception for simplecov because that will already have been
# required and run at the very top of spec_helper.rb
support_files = Dir["./spec/support/**/*.rb"].reject { |file| file == "./spec/support/simplecov.rb" }
support_files.each { |f| require f }

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
