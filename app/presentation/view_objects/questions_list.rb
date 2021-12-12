# frozen_string_literal: true

require_relative 'question'

module Views
  # View for a single questions list entity
  class QuestionsList
    def initialize(questions)
      @questions = questions.map.with_index { |question, index| Question.new(question, index) }
    end

    def each(&block)
      @questions.each(&block)
    end

    def any?
      @questions.any?
    end
  end
end
