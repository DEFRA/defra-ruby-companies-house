# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

group :development, :test do
  gem "defra_ruby_style", "~> 0.3"

  # Shim to load environment variables from a .env file into ENV
  gem "dotenv"

  gem "faker"

  # Allows us to automatically generate the change log from the tags, issues,
  # labels and pull requests on GitHub. Added as a dependency so all dev's have
  # access to it to generate a log, and so they are using the same version.
  # New dev's should first create GitHub personal app token and add it to their
  # ~/.bash_profile (or equivalent)
  # https://github.com/skywinder/github-changelog-generator#github-token
  gem "github_changelog_generator"

  # Adds step-by-step debugging and stack navigation capabilities to pry using byebug
  gem "pry-byebug"

  # gem "rake"

  gem "rspec"
  gem "rspec-rails"

  gem "rubocop", require: false
  gem "rubocop-rake", require: false
  gem "rubocop-rspec"
  gem "rubocop-rspec_rails"

  gem "simplecov", "~> 0.22.0", require: false

  gem "webmock"
end

gemspec
