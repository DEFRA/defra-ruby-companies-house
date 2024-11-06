# frozen_string_literal: true

require "logger"

require_relative "companies_house/version"
require_relative "companies_house/configuration"
require_relative "companies_house/api"

# The DefraRuby::CompaniesHouse module facilitates integration with the Companies House API.
# It provides a consistemt, convenient way to interact with the Companies House API in Defra's ruby applications.
module DefraRuby
  module CompaniesHouse
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    # Use DefraRubyGovpay.logger if it exists, else use a simple console logger
    def self.logger
      @logger ||= defined?(Rails) ? Rails.logger : Logger.new($stdout)
    end

    def self.logger=(logger)
      @logger = logger
    end
  end
end
