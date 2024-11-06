# frozen_string_literal: true

require "spec_helper"
require "defra_ruby/companies_house/api"

RSpec.describe DefraRuby::CompaniesHouse::API do

  subject(:companies_house_response) { described_class.run(company_number) }

  let(:companies_house_endpoint) { "#{DefraRuby::CompaniesHouse.configuration.companies_house_host}/company" }
  let(:valid_company_number) { "00987654" }
  let(:company_number) { valid_company_number }

  let(:config) { DefraRuby::CompaniesHouse.configuration }

  before do
    DefraRuby::CompaniesHouse.configure do |config|
      config.companies_house_host = Faker::Internet.url
      config.companies_house_api_key = "a_companies_house_api_key"
    end

    # stub all calls to fail first....
    stub_request(:get, %r{#{companies_house_endpoint}/*}).to_return(status: 404)
    # ... then add a stub to cover a valid company_number
    stub_request(:get, %r{#{companies_house_endpoint}/[a-zA-Z\d]{8}}).to_return(
      status: 200,
      body: File.read("spec/fixtures/files/companies_house_response.json")
    )
  end

  shared_examples "Airbrake notifications" do
    context "when Airbrake is enabled" do
      before do
        stub_const("Airbrake", Class.new)
        allow(Airbrake).to receive(:notify)
      end

      it "Airbrake notifications" do
        companies_house_response
      rescue StandardError # expected exception
        expect(Airbrake).to have_received(:notify)
      end
    end
  end

  context "when the API request times out" do
    before { stub_request(:get, %r{#{companies_house_endpoint}/*}).to_timeout }

    it { expect { companies_house_response }.to raise_error(DefraRuby::CompaniesHouse::ApiTimeoutError) }

    it_behaves_like "Airbrake notifications"
  end

  context "when the API returns an error" do
    before { stub_request(:get, %r{#{companies_house_endpoint}/*}).to_raise(SocketError) }

    it { expect { companies_house_response }.to raise_error(StandardError) }

    it_behaves_like "Airbrake notifications"
  end

  context "with an invalid company number format" do
    let(:company_number) { "0000" }

    it { expect { companies_house_response }.to raise_error(DefraRuby::CompaniesHouse::InvalidCompanyNumberError) }

    it_behaves_like "Airbrake notifications"
  end

  context "with a valid format company number with no matching company" do
    let(:company_number) { "98765432" }

    before { stub_request(:get, %r{#{companies_house_endpoint}/[a-zA-Z\d]{8}}).to_return(status: 404) }

    it { expect { companies_house_response }.to raise_error(DefraRuby::CompaniesHouse::CompanyNotFoundError) }
  end

  context "when the company is no longer active" do
    before do
      stub_request(:get, %r{#{companies_house_endpoint}/[a-zA-Z\d]{8}}).to_return(
        status: 200,
        body: File.read("spec/fixtures/files/inactive_companies_house_response.json")
      )
    end

    it { expect(companies_house_response[:company_status]).to eq :inactive }
  end

  context "when the company is active" do

    shared_examples "returns a valid result" do
      it { expect(companies_house_response[:company_name]).to eq "BOGUS LIMITED" }
      it { expect(companies_house_response[:company_type]).to eq :ltd }
      it { expect(companies_house_response[:company_status]).to eq :active }
      it { expect(companies_house_response[:registered_office_address]).to eq ["R House", "Middle Street", "Thereabouts", "HD1 2BN"] }
    end

    context "with a full-length company number" do
      let(:company_number) { valid_company_number }

      it_behaves_like "returns a valid result"
    end

    context "with a short company number" do
      let(:company_number) { "1987654" }

      it_behaves_like "returns a valid result"
    end

    context "with a lower case company number" do
      let(:company_no) { "xy12345z" }

      it_behaves_like "returns a valid result"
    end
  end
end
