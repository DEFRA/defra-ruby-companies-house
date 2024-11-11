# frozen_string_literal: true

require "rest-client"

# for deep_symbolize_keys
require "active_support/core_ext/hash/keys"

module DefraRuby
  module CompaniesHouse

    # https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/426891/uniformResourceIdentifiersCustomerGuide.pdf
    VALID_COMPANY_NUMBER_NUMBER_REGEX = /\A(\d{8,8}$)|([a-zA-Z]{2}\d{6}$)|([a-zA-Z]{2}\d{5}[a-zA-Z]{1}$)\z/i

    # Custom error classes to handle Companies House API errors
    class ApiTimeoutError < StandardError
      def message
        "Companies House API timeout"
      end
    end

    class InvalidCompanyNumberError < StandardError
      def initialize(company_number)
        @company_number = company_number
        super
      end

      def message
        "Invalid company number: #{@company_number}"
      end
    end

    class CompanyNotFoundError < StandardError
      def initialize(company_number)
        @company_number = company_number
        super
      end

      def message
        "Company not found: #{@company_number}"
      end
    end

    # The API class is responsible for making requests to the Companies House API.
    # It handles the construction of request URLs, headers, and payload,
    # and also deals with any errors that occur during the API request.
    class API

      attr_accessor :company_number

      def self.run(company_number:)
        new.run(company_number:)
      end

      def run(company_number:)
        @company_number = format_company_number(company_number)
        validate_company_number

        companies_house_details
      rescue InvalidCompanyNumberError
        # just re-raise - this is to prevent the StandardError rescue logging it again
        raise
      rescue RestClient::Exceptions::Timeout => e
        log_error(e)
        raise DefraRuby::CompaniesHouse::ApiTimeoutError
      rescue RestClient::ResourceNotFound, RestClient::NotFound => e
        log_error(e)
        raise DefraRuby::CompaniesHouse::CompanyNotFoundError, company_number
      rescue StandardError => e
        log_error(e)
        raise e
      end

      private

      def companies_house_details
        @companies_house_details ||= {
          company_name: companies_house_api_response[:company_name],
          company_type: companies_house_api_response[:type].to_sym,
          company_status: companies_house_api_response[:company_status].to_sym,
          registered_office_address: registered_office_address_lines
        }
      end

      def companies_house_api_response
        @companies_house_api_response ||= JSON.parse(
          RestClient::Request.execute(
            method: :get,
            url: companies_house_endpoint,
            user: api_key,
            password: ""
          )
        ).deep_symbolize_keys
      end

      def companies_house_endpoint
        "#{DefraRuby::CompaniesHouse.configuration.companies_house_host}/company/#{company_number}"
      end

      def api_key
        DefraRuby::CompaniesHouse.configuration.companies_house_api_key
      end

      # rubocop:disable Naming/VariableNumber
      def registered_office_address_lines
        address = companies_house_api_response[:registered_office_address]

        [
          address[:address_line_1],
          address[:address_line_2],
          address[:locality],
          address[:postal_code]
        ].compact
      end
      # rubocop:enable Naming/VariableNumber

      def validate_company_number
        return if company_number.match?(VALID_COMPANY_NUMBER_NUMBER_REGEX) && !company_number.match(/^0+$/)

        error = DefraRuby::CompaniesHouse::InvalidCompanyNumberError.new(company_number)

        log_error(error)
        raise error
      end

      def format_company_number(raw_company_number)
        raw_company_number.to_s.upcase.rjust(8, "0")
      end

      def log_error(error)
        logged_error = "Error getting details for company \"#{company_number}\": #{error}"
        DefraRuby::CompaniesHouse.logger.error logged_error
        Airbrake.notify(logged_error) if defined?(Airbrake)
      end
    end
  end
end
