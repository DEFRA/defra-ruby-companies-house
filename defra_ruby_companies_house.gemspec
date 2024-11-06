# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem"s version:
require "defra_ruby/companies_house/version"

Gem::Specification.new do |spec|
  spec.name          = "defra_ruby_companies_house"
  spec.version       = DefraRuby::CompaniesHouse::VERSION
  spec.authors       = ["Defra"]
  spec.email         = ["pauldoyle1@environment-agency.gov.uk"]
  spec.license       = "The Open Government Licence (OGL) Version 3"
  spec.homepage      = "https://github.com/DEFRA/defra-ruby-companies-house"
  spec.summary       = "Defra ruby on rails helper for Companies House API"
  spec.description   = "Single point of access to the Companies House API with associated " \
                       "error handling, used in Defra Rails based digital services"
  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir["{bin,config,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  spec.require_paths = ["lib"]

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise "RubyGems 2.0 or newer is required to protect against public gem pushes." unless spec.respond_to?(:metadata)

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  # require MFA to push to RubyGems.org
  spec.metadata["rubygems_mfa_required"] = "true"

  # Use rest-client for external requests
  spec.add_dependency "rest-client", "~> 2.0"
end
