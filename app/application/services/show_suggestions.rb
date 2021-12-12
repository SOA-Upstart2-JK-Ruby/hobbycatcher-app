# frozen_string_literal: true

require 'dry/transaction'

module HobbyCatcher
  module Service
    # Retrieves array of all listed hobby entities
    class ShowSuggestion
      include Dry::Transaction

      step :get_api_suggestions
      step :reify_suggestions

      def get_api_suggestions(hobby_id)
        result = Gateway::Api.new(HobbyCatcher::App.config)
          .suggestions(hobby_id)

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts "#{e.inspect} \n #{e.backtrace}"
        Failure('Cannot get your hobby suggestions right now; please try again later')
      end

      def reify_suggestions(project_json)
        Representer::Suggestion.new(OpenStruct.new)
          .from_json(project_json)
          .then { |suggestion| Success(suggestion) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end
