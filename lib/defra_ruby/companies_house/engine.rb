# frozen_string_literal: true

require "defra_ruby/companies_house"

module DefraRuby
  module CompaniesHouse
    class Engine < ::Rails::Engine
      isolate_namespace DefraRuby::CompaniesHouse

      # Add a load path for this specific Engine
      config.autoload_paths += Dir[File.join(config.root, "lib", "**")]

      # Load I18n translation files from engine before loading ones from the host app
      # This means values in the host app can override those in the engine
      config.before_initialize do
        engine_locales = Dir["#{config.root}/config/locales/**/*.yml"]
        config.i18n.load_path = engine_locales + config.i18n.load_path
      end
    end
  end
end
