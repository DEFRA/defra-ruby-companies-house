# Defra Ruby Companies House

![Build Status](https://github.com/DEFRA/defra-ruby-companies-house/workflows/CI/badge.svg?branch=main)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_defra-ruby-companies-house&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=DEFRA_defra-ruby-companies-house)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_defra-ruby-companies-house&metric=coverage)](https://sonarcloud.io/dashboard?id=DEFRA_defra-ruby-companies-house)
[![Gem Version](https://badge.fury.io/rb/defra_ruby_companies_house.svg)](https://badge.fury.io/rb/defra_ruby_companies_house)
[![Licence](https://img.shields.io/badge/Licence-OGLv3-blue.svg)](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

Single point of access to the Companies House API with standardised initial error handling.

## Installation

Add this line to your application's Gemfile

```ruby
gem "defra_ruby_companies_house"
```

And then update your dependencies by calling

```bash
bundle install
```

## Usage
Call the Api.run method with the company number:

```ruby
DefraRuby::CompaniesHouse.run("12345678")
```
If the company is found, the response will consist of a Hash including:
- `company_name`
- `company_type`, e.g. "ltd", "llp", "plc"
- `company_status`, e.g. "active"
- `registered_address`, an array of address lines

## Error handling
The gem catches errors from the Companies House API and from the REST client and maps them to custom errors as follows.
- Company not found: `DefraRuby::CompaniesHouse::CompanyNotFoundError`
- Companies House API timeout: `DefraRuby::CompaniesHouse::ApiTimeoutError`
- General Companies House API errors: `DefraRuby::CompaniesHouse::ApiError`

The gem will log these errors to Airbrake if it is enabled, in which case there is no need for the app to also log the error.

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3

The following attribution statement MUST be cited in your products and applications when using this information.

> Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
