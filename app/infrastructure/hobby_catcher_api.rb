# frozen_string_literal: true

require 'http'

module HobbyCatcher
  module Gateway
    # Infrastructure to call HobbyCatcher API
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def test
        @request.test
      end

      def get_answer(answer)
        @request.get_answer(answer[0], answer[1], answer[2], answer[3])
      end

      # Gets appraisal of a project folder rom API
      # - req: ProjectRequestPath
      #        with #owner_name, #project_name, #folder_name, #project_fullname
      def suggestions(hobby_id)
        @request.get_suggestions(hobby_id)
      end

      # HTTP request transmitter
      class Request
        def initialize(config)
          @api_host = config.API_HOST
          @api_root = "#{config.API_HOST}/api/v1"
        end

        def get_root # rubocop:disable Naming/AccessorMethodName
          call_api('get')
        end

        def test
          call_api('get', ['test'])
        end

        def get_answer(type, difficulty, freetime, emotion)
          call_api('post', ['suggestion'],
                          'type'       => type,
                          'difficulty' => difficulty,
                          'freetime'   => freetime,
                          'emotion'    => emotion)
        end

        def get_suggestions(hobby_id)
          call_api('get', ['suggestion', hobby_id])
        end

        private

        def params_str(params)
          params.map { |key, value| "#{key}=#{value}" }.join('&')
            .then { |str| str ? "? #{str}" : '' }
        end

        def call_api(method, resources = [], params = {})
          api_path = resources.empty? ? @api_host : @api_root
          url = [api_path, resources].flatten.join('/') + params_str(params)
          HTTP.headers('Accept' => 'application/json').send(method, url)
            .then { |http_response| Response.new(http_response) }
        rescue StandardError
          raise "Invalid URL request: #{url}"
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        SUCCESS_CODES = (200..299).freeze

        def success?
          code.between?(SUCCESS_CODES.first, SUCCESS_CODES.last)
        end

        def message
          payload['message']
        end

        def payload
          body.to_s
        end
      end
    end
  end
end
