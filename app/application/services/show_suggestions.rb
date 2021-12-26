# frozen_string_literal: true

require 'dry/transaction'

module HobbyCatcher
  module Service
    # Retrieves array of all listed hobby entities
    class ShowSuggestion
      include Dry::Transaction

      step :get_api_suggestions
      step :reify_suggestions

      def get_api_suggestions(input)
        input[:response] = Gateway::Api.new(HobbyCatcher::App.config)
          .suggestions(input[:requested])

        input[:response].success? ? Success(input) : Failure(input[:response].message)
      rescue StandardError
        Failure('Cannot get your hobby suggestions right now; please try again later')
      end

      def reify_suggestions(input)
        unless input[:response].processing?
          Representer::Suggestion.new(OpenStruct.new)
            .from_json(input[:response].payload)
            .then { input[:appraised] = _1 }
        end

        Success(input)
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end
