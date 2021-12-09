# frozen_string_literal: true

require 'dry/transaction'

# :reek:FeatureEnvy
module HobbyCatcher
  module Service
    # Retrieves array of all listed hobby entities
    class GetAnswer
      include Dry::Transaction

      step :validate_answer
      step :retrieve_hobby
      step :reify_hobby

      private

      # Expects answer in input
      def validate_answer(input)
        if (input.length).equal? 4
          Success(input)
        else
          Failure('you need to finish all questions')
        end
      end

      def retrieve_hobby(input)
        result = Gateway::Api.new(HobbyCatcher::App.config)
        .get_answer(input)

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect + '\n' + e.backtrace
        Failure('Cannot get your hobby right now; please try again later')
      end

      def reify_hobby(project_json)
        Representer::Hobby.new(OpenStruct.new)
          .from_json(project_json)
          .then { |hobby| Success(hobby) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end
