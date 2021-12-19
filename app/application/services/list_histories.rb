# frozen_string_literal: true

require 'dry/transaction'

module HobbyCatcher
  module Service
    # Retrieves array of all listed hobby entities
    class ListHistories
      include Dry::Transaction

      step :get_api_list
      step :reify_list

      private

      DB_ERR = 'Cannot access database'

      # Expects list of movies in input[:list_request]
      def get_api_list(records_list)
        Gateway::Api.new(HobbyCatcher::App.config)
          .list_histories(records_list)
          .then do |result|
            result.success? ? Success(result.payload) : Failure(result.message)
          end
      rescue StandardError
        Failure('Could not access our API')
      end

      def reify_list(records_json)
        Representer::RecordList.new(OpenStruct.new)
          .from_json(records_json)
          .then { |records| Success(records) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end
