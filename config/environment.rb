# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'delegate' # needed until Rack 2.3 fixes delegateclass bug

module HobbyCatcher
  # Environment-specific configuration
  class App < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment: environment,
      path:        File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config() = Figaro.env

    use Rack::Session::Cookie, secret: config.SESSION_SECRET

    configure :development, :test, :app_test do
      require 'pry'; # for breakpoints
    end

    configure :app_test do
      require_relative '../spec/helpers/vcr_helper'
      VcrHelper.setup_vcr
      VcrHelper.configure_vcr_for_udemy(recording: :none)
    end
  end
end
