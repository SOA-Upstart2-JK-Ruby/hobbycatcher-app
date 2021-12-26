# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'yaml'

# :reek:RepeatedConditiona
module HobbyCatcher
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :caching
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_row.js'

    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs

    # rubocop:disable Metrics/BlockLength
    route do |routing|
      routing.assets # load CSS
      routing.public

      # GET /
      routing.root do
        # Get cookie viewer's previously seen test history
        session[:watching] ||= []
        view 'home'
      end

      routing.on 'test' do
        routing.is do
          routing.post do
            routing.redirect 'test'
          end

          routing.get do
            result = Service::ShowTest.new.call

            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            else
              questions = result.value!
              viewable_questions = Views::QuestionsList.new(questions)
            end

            response.expires 60, public: true
            view 'test', locals: { questions: viewable_questions }
          end
        end
      end

      routing.on 'history' do
        routing.post do
          # hobby = routing.params['delete']
          # delete_item = nil
          # session[:watching].each do |item|
          #   delete_item = item if item == hobby
          # end
          session[:watching].delete(routing.params['delete'])

          routing.redirect '/history'
        end

        routing.is do
          routing.get do
            # Load previously viewed hobbies
            result = Service::ListHistories.new.call(session[:watching])

            if result.failure?
              flash[:error] = result.failure
              viewable_hobbies = []
            else
              hobbies = result.value!.records
              flash.now[:notice] = 'Catch your hobby first to see history.' if hobbies.empty?

              viewable_hobbies = Views::HobbiesList.new(hobbies)
            end

            response.expires 60, public: true
            view 'history', locals: { hobbies: viewable_hobbies }
          end
        end
      end

      routing.on 'suggestion' do
        routing.is do
          # POST /introhobby/
          routing.post do
            url_request = Forms::AddAnswer.new.call(routing.params)

            if url_request.failure?
              flash[:error] = 'Seems like you did not answer all of the questions'
              response.status = 400
              routing.redirect '/test'
            end
            # Success([@params['type'], @params['difficulty'], @params['freetime'], @params['emotion']])
            # url_req = Request::AddAnswer.new(routing.params)
            # result = Service::GetAnswer.new.call(url_request: url_req)
            answer = [url_request[:type], url_request[:difficulty], url_request[:freetime], url_request[:emotion]]
            result = Service::GetAnswer.new.call(answer)
            hobby = result.value!
            # Add new record to watched set in cookies
            record = [hobby.id, hobby.updated_at].join(';')
            session[:watching].insert(0, record).uniq!
            # Redirect viewer to project page
            routing.redirect "suggestion/#{hobby.id}"
          end
        end

        routing.on String do |hobby_id|
          # GET /introhoppy/hobby
          routing.get do
            result = Service::ShowSuggestion.new.call(requested: hobby_id)
            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end

            suggestions = OpenStruct.new(result.value!)
            if suggestions.response.processing?
              flash.now[:notice] = 'Loading courses...'
            else
              viewable_hobby = Views::Suggestion.new(suggestions.appraised)
              response.expires(60, public: true) if App.environment == :production
            end

            processing = Views::SuggestionProcessing.new(
              App.config, suggestions.response
            )

            # response.expires 60, public: true
            view 'suggestion', locals: { hobby: viewable_hobby, processing: processing }
          end
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
