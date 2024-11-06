# frozen_string_literal: true

require "spec_helper"

RSpec.describe DefraRuby::CompaniesHouse do
  describe "VERSION" do
    it { expect(DefraRuby::CompaniesHouse::VERSION).to be_a(String) }
    it { expect(DefraRuby::CompaniesHouse::VERSION).to match(/\d+\.\d+\.\d+/) }
  end

  describe ".logger" do
    it { expect(described_class.logger).to be_a(Logger) }
  end
end
