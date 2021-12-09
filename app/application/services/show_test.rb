# frozen_string_literal: true

require 'dry/transaction'

module HobbyCatcher
  module Service
    # Retrieves array of all listed hobby entities
    class ShowTest
      include Dry::Transaction

      step :get_api_test
      step :reify_test

      private

      def get_api_test

        result = Gateway::Api.new(HobbyCatcher::App.config).test
        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect + '\n' + e.backtrace
        Failure('Cannot get test list right now; please try again later')
      end

      def reify_test(project_json)
        Representer::Test.new(OpenStruct.new)
        .from_json(project_json)
        .then { |test| Success(test) }
      rescue StandardError
        Failure('Could not parse response from API')
      end

    end
  end
end
